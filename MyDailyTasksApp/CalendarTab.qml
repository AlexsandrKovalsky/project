import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import App 1.0

Item {

    Component.onCompleted: {
        allTasksProgressPercent.text = "Общий прогресс: выполнено " + App.tasksManager.getAllTasksProgressPercent() + "%";
    }

    property int selectedTaskId: -1
    property string selectedTaskDescription: ""
    property int selectedTaskImportanceValue: -1
    property string selectedTaskDate: ""

    Calendar{
        id: dayTasksCalendar
        width:parent.width / 2
        height: parent.height / 1.5
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            var currentDate = Qt.formatDate(dayTasksCalendar.selectedDate, "dd-MM-yyyy")
            console.log(currentDate);
            App.tasksManager.getTasksForDay(currentDate);
            dayTasksDialog.open();
            progressPercentText.text = "Выполнено: " +
                    App.tasksManager.getDayTasksProgressPercent(currentDate) + "%";
        }
    }

    Text {
        id: allTasksProgressPercent
        text: "Общий прогресс: выполнено "
        font.pointSize: 13
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Dialog{
        id: dayTasksDialog
        width: parent.width / 1.3
        height: parent.height / 1.3

        onAccepted: {
            selectedTaskId = -1;
            allTasksProgressPercent.text = "Выполнено: " + App.tasksManager.getAllTasksProgressPercent() + "%";
        }

        Text {
            id: currentDateText
            text: Qt.formatDate(dayTasksCalendar.selectedDate, "dd-MM-yyyy") + ":"
            font.pointSize: 14
        }

        ListView{
            id: dayTasksListView
            width: parent.width
            height: parent.height / 2
            anchors.topMargin: 10
            anchors.top: currentDateText.bottom
            anchors.leftMargin: 3
            clip: enabled
            header:
                Item{
                    width: parent.width
                    height: 30
                    Rectangle{
                        anchors.fill: parent
                        Row{
                            spacing: 10
                            width: parent.width
                            height: parent.height
                            Text {
                                width: parent.width / 2
                                height: 30
                                text: "Описание задачи"
                                font.pointSize: 14
                            }

                            Text{
                                width: parent.width / 4
                                text: "Приоритет"
                                font.pointSize: 14
                            }

                            Text{
                                width: parent.width / 5
                                text: "Сделано"
                                font.pointSize: 14
                            }
                        }
                    }
            }
            delegate:
                Item{
                    width: parent.width
                    height: 30
                    Rectangle{
                        anchors.fill: parent
                        border.color: model.id===selectedTaskId ? "black" : "transparent"
                        Row{
                            spacing: 10
                            width: parent.width
                            height: parent.height
                            Text {
                                id: taskDescription
                                text: model.description
                                width: parent.width / 2
                                height: 30
                                elide: Text.ElideRight
                                font.pointSize: 14
                                font.strikeout: checkBox.checked
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(selectedTaskId===model.id){
                                            fullTextText.text = model.description;
                                            fullTextDialog.open();
                                        }
                                        selectedTaskId = model.id;
                                        selectedTaskDescription = model.description;
                                        selectedTaskImportanceValue = model.importance;
                                        selectedTaskDate = model.date;
                                    }
                                }
                            }

                            Text {
                                width: parent.width/4

                                text: model.importance >= 9 ? "Оч. высокий" :
                                      model.importance >= 7 ? "Высокий" :
                                      model.importance >= 5 ? "Средний" :
                                      model.importance >=3 ? "Низкий" :
                                                            "Оч. низкий"
                                font.pointSize: 14


                            }

                            CheckBox{
                                id: checkBox
                                checked: model.completed
                                onCheckedChanged: {
                                    App.tasksManager.updateTask(model.id, checkBox.checked);
                                    progressPercentText.text = "Выполнено: " +
                                            App.tasksManager.getDayTasksProgressPercent(Qt.formatDate(dayTasksCalendar.selectedDate, "dd-MM-yyyy")) + "%";
                                }
                            }

                        }
                    }

            }
            model: App.tasksManager.calendarDayTasksModel
        }

        Text{
            id: progressPercentText
            text: "Выполнено: "
            font.pointSize: 12
            anchors.top: dayTasksListView.bottom
            anchors.topMargin: 20
        }

        Row{
            width: parent.width
            height: 40
            id: taskButtonsRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: progressPercentText.bottom
            anchors.topMargin: 20
            spacing: 10
            Button{
                id: addTaskButton
                width: parent.width / 4
                height: 40
                text: "Добавить задачу"
                onClicked: {
                    addTaskDialog.open();
                }
            }
            Button{
                text: "Изменить"
                width: parent.width / 4
                height: 40
                enabled: selectedTaskId !== -1
                onClicked: {
                    editTaskDescriptionField.text = selectedTaskDescription;
                    editTaskDateText.text = selectedTaskDate;
                    editTaskImportanceField.value = selectedTaskImportanceValue;
                    editTaskDialog.open();
                }
            }

            Button{
                text: "Удалить"
                width: parent.width / 4
                height: 40
                enabled: selectedTaskId !== -1
                onClicked: {
                    App.tasksManager.deleteTask(selectedTaskId);
                    App.tasksManager.getTasksForDay(Qt.formatDate(dayTasksCalendar.selectedDate, "dd-MM-yyyy"));
                }
            }

        }
    }

    Dialog{
        id: addTaskDialog
        width: parent.width / 1.3
        height: parent.height / 1.3

        Column{
            Row{
                spacing: 5
                Text {
                    text: qsTr("Описание задачи")
                    font.pointSize: 14
                }

                TextArea{
                    id: descriptionField
                    width: addTaskDialog.width / 2
                    height: addTaskDialog.height / 2
                    font.pointSize: 12
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignTop
                    wrapMode: TextEdit.WrapAnywhere
                }
            }

            Row{
                spacing: 5
                Text {
                    text: qsTr("Важность задачи")
                    font.pointSize: 14
                }
                Slider{
                    id: importanceField
                    width: 200
                    height: 40
                    minimumValue: 0
                    maximumValue: 10
                    value: 5
                }
            }
        }
        onAccepted: {
            if(descriptionField.text.length!==0)
                App.tasksManager.addTask(descriptionField.text.toString(),
                                         false, importanceField.value,
                                         Qt.formatDate(dayTasksCalendar.selectedDate, "dd-MM-yyyy"))
                App.tasksManager.getTasksForDay(
                    Qt.formatDate(dayTasksCalendar.selectedDate, "dd-MM-yyyy"));
                descriptionField.text = "";
                importanceField.value = 0;
        }
    }

    Dialog{
        id: fullTextDialog
        width: parent.width / 2
        height: parent.height / 2
        ScrollView{
            anchors.fill: parent
            verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
            horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
            TextArea {
                id: fullTextText
                text: qsTr("text")
                font.pointSize: 12
                wrapMode: TextEdit.WrapAnywhere
                readOnly: enabled
            }
        }
    }

    Dialog{
        id: editTaskDialog
        width: parent.width / 1.3
        height: parent.height / 1.3

        onAccepted: {
            if(editTaskDescriptionField.text!=="")
            App.tasksManager.updateTask(selectedTaskId, editTaskDescriptionField.text,
                                        editTaskImportanceField.value, editTaskDateText.text)
            App.tasksManager.getTasksForDay(Qt.formatDate(dayTasksCalendar.selectedDate, "dd-MM-yyyy"));
        }
        Column{
            Row{
                spacing: 5
                Text {
                    text: qsTr("Описание задачи")
                    font.pointSize: 14
                }
                TextArea{
                    id: editTaskDescriptionField
                    width: addTaskDialog.width / 2
                    height: addTaskDialog.height / 2
                    font.pointSize: 12
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignTop
                    wrapMode: TextEdit.WrapAnywhere
                }
            }
            Row{
                spacing: 5
                Text {
                    text: qsTr("Важность задачи")
                    font.pointSize: 14
                }
                Slider{
                    id: editTaskImportanceField
                    width: 200
                    height: 40
                    minimumValue: 0
                    maximumValue: 10
                    value: 5
                }
            }
            Row{
                spacing: 5
                Text {
                    text: qsTr("Дата: ")
                    font.pointSize: 14
                }
                Text {
                    id: editTaskDateText
                    font.pointSize: 14

                }
                Button{
                    text: "Изменить"
                    onClicked: pickDateDialog.open();
                }
            }
    }

    Dialog{
        id: pickDateDialog
        width: parent.width / 2
        height: parent.height / 2
        Calendar{
            id: pickDateCalendar

        }

        onAccepted: {
            editTaskDateText.text = Qt.formatDate(pickDateCalendar.selectedDate, "dd-MM-yyyy");
        }
    }
    }
}
