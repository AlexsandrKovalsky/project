import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.5
import App 1.0

Window {
    visible: true
    width: 720
    height: 480
    title: qsTr("Мои задачи")
    property var forms : ["CalendarTab.qml", "ImportantTasksTab.qml", "BurningTasksTab.qml"]

    TabBar{
        id: myTabBar
        width: parent.width
        height: 60

        TabButton{
            text: "Календарь"
        }

        TabButton{
            text: "Важное"
        }

        TabButton{
            text: "Горящие сроки"
        }

    }

    Loader{
        width: parent.width
        height: parent.height - myTabBar.height
        anchors.top: myTabBar.bottom
        source: forms[myTabBar.currentIndex]
    }
}
