import QtQuick
import QtQuick.Controls

Window {
    width: 680
    height: 680
    visible: true
    title: qsTr("FMathCurve")
    color: "#FFFDD0"


    property bool snaptogrid: false




    // timer values
    property int seconds: 0
    property int maxseconds: 25
    property int milliseconds: 0


    function timerTriggered(){

        milliseconds++

        if(milliseconds >= 10){
            seconds++
            milliseconds = 0
        }


        if(seconds >= maxseconds){
            timer.stop()
            milliseconds = 0
            seconds = 0
        }


    }

    Timer{
        id: timer
        interval: 100
        repeat: true
        running: false
        onTriggered: { timerTriggered() }
    }

    Row{
        id: row
        height: 34
        spacing: 20
        width: parent.width-20
        x:10
        y: 10
        Button{
            id: startbutton
            text: "Start"
            width: 60
            height: 30
            contentItem: Text {
                id: text
                text: timer.running ? qsTr("Pause") : qsTr("Start")
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 11
                font.letterSpacing: 2
            }
            onClicked: {

                timer.running ? timer.stop() : timer.start()

            }
        }

        CheckBox{
            id: snap
            text: qsTr("Snap to grid")
            height: row.height
            width: 110
            contentItem: Text {
                id: boxtext
                text: qsTr("Snap to grid")
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 10
                font.letterSpacing: 1.5
            }
        }

        onStateChanged: {

            snap.checked ? snaptogrid = true : snaptogrid = false

        }
    }


    // Image
    Rectangle{
        id: graphrect
        width: 514
        height: 514
        anchors.centerIn: parent
        color: "transparent"
        border.color: "magenta"

        Image {
            id: graph
            source: "/svg/Graph.svg"
            width: 512
            height: 512
            anchors.centerIn: parent
        }
    }


    // Timerrect
    Rectangle{
        id: timerrect
        width: 250
        height: 30
        anchors.left: graphrect.left
        anchors.top: graphrect.bottom
        anchors.topMargin: 10
        border.color: "green"
        color: "transparent"

        Rectangle{
            id: fillrect
            width: timerrect.width/(maxseconds-0.5) * seconds
            height: timerrect.height-2
            x:1; y:1
            color: "green"
        }


        Text {
            id: timertext
            text: seconds + "." + milliseconds
            font.pointSize: 12
            anchors.centerIn: parent
            color: fillrect.width >= timerrect.width/2 ? "white" : "green"
        }


    }




}
