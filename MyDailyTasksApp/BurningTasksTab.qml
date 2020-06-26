import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import App 1.0

Item {
    Component.onCompleted: {
        App.tasksManager.getBurningTasks();
    }

    property int selectedTaskId: -1
    property string selectedTaskDescription: ""
    property int selectedTaskImportanceValue: -1
    property string selectedTaskDate: ""

    function getDeadlinesText(count){
        if(count===0) return "Горящих дедлайнов нет";
        var lastPart = ""
        if(count%10===1 && count!==11)
            lastPart = " горящий дедлайн!"
        else if((count%10===2 || count%10===3 || count%10===4)
                && count!==12 && count!==13 && count!==14)
            lastPart = " горящих дедлайна!"
        else
            lastPart = " горящих дедлайнов!"
        return "У вас " + count + lastPart
    }

    Text {
        id: burningTasksText
        text: getDeadlinesText(parseInt(burningTasksListView.count))
        font.pointSize: 14
    }

    ListView{
        id: burningTasksListView
        width: parent.width
        height: parent.height / 1.5
        anchors.top: burningTasksText.bottom
        anchors.topMargin: 20
        clip: enabled
        header:
            Item{
                width: parent.width
                height: 50
                Rectangle{
                    anchors.fill: parent
                    Row{
                        width: parent.width
                        spacing: 10
                        Text {
                            text: "Описание задачи"
                            font.pointSize: 14
                            width: parent.width / 3
                        }

                        Text{
                            text: "Дата"
                            font.pointSize: 14
                            width: parent.width / 4
                        }

                        Text{
                            text: "Приоритет"
                            font.pointSize: 14
                            width: parent.width / 5
                        }

                        Text{
                            text: "Сделано"
                            font.pointSize: 14
                            width: parent.width / 5
                        }
                    }
                }
            }
        delegate:
            Item{
                width: parent.width
                height: 50
                Rectangle{
                    anchors.fill: parent
                    border.color: model.id===selectedTaskId ? "black" : "transparent"
                    color: model.date < Qt.formatDate(new Date(), "dd-MM-yyyy") ? "red" :
                    model.date === Qt.formatDate(new Date(), "dd-MM-yyyy") ? "orange": "green"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log();
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
                    Row{
                        anchors.fill: parent
                        spacing: 10
                        Text {
                            id: taskDescription
                            width: parent.width / 3
                            text: model.description
                            font.pointSize: 14
                            elide: Text.ElideRight
                            font.strikeout: taskCompleted.checked
                        }

                        Text{
                            id: taskDate
                            width: parent.width / 4
                            text: model.date
                            font.pointSize: 14
                        }

                        Text{
                            id: taskImportance
                            width: parent.width / 5
                            text: model.importance >= 9 ? "Оч. высокий" :
                                  model.importance >= 7 ? "Высокий" :
                                  model.importance >= 5 ? "Средний" :
                                  model.importance >= 3 ? "Низкий" :
                                                          "Оч. низкий"
                            font.pointSize: 14
                        }

                        CheckBox{
                            id: taskCompleted
                            width: parent.width / 5
                            checked: model.completed
                            onCheckedChanged: {
                                App.tasksManager.updateTask(model.id, taskCompleted.checked);
                            }
                        }
                    }
                }
        }
        model: App.tasksManager.burningTasksModel
    }

    Row{
        width: parent.width
        height: 40
        id: taskButtonsRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: burningTasksListView.bottom
        anchors.topMargin: 20
        spacing: 10
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
                App.tasksManager.getBurningTasks();
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
            App.tasksManager.getBurningTasks();
        }
        Column{
            anchors.fill: parent
            Row{
                spacing: 5
                Text {
                    text: qsTr("Описание задачи")
                    font.pointSize: 14
                }
                TextArea{
                    id: editTaskDescriptionField
                    width: editTaskDialog.width / 2
                    height: editTaskDialog.height / 2
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
}
