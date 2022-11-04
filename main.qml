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


    function updateCurve(){
        canvas.clearCanvas()
        canvas.markDirty(Qt.rect(canvas.x,canvas.y,canvas.width,canvas.height))
    }

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
            source: "/png/graph.png"
            width: 512
            height: 512
            anchors.centerIn: parent
        }

        Canvas{
            id: canvas
            anchors.centerIn: graph
            width: graphrect.width
            height: graphrect.height
            x:0
            contextType: "2d"
            Path {
                id: curvePath
                startX: point1.x + 6 ; startY: point1.y + 6

                PathLine { x: point2.x + 6; y: point2.y + 6 }


            }

            onPaint: {
                context.strokeStyle = Qt.rgba(.4,.6,.8);
                context.path = curvePath;
                context.stroke();
            }

            function clearCanvas(){
               var ctx = canvas.getContext("2d")
               ctx.reset()
            }
        }


        // Magentapoint
        Rectangle{
            id: mpoint
            width: 12
            height: 12
            radius: 6
            color: "magenta"
            x: 250
            y: 250
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                enabled: true
                drag.target: mpoint
                drag.axis: Drag.XandYAxis
                onReleased: {
//                    mx = mpoint.x
//                    my = mpoint.y


                }
            }
        }

        Rectangle{
            id: point1
            width: 12
            height: 12
            radius: 6
            color: "green"
            border.color: "lightgray"
            x: 50
            y: 50
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                enabled: true
                drag.target: point1
                drag.axis: Drag.XandYAxis
                onReleased: {
//                    p1x = point1.x + 2.5
//                    p1y = point1.y + 2.5

//                    if(snaptogrid){
//                        p1x = snapToGridX(point1.x + 2.5)
//                        p1y = snapToGridY(point1.y + 2.5)
//                    }

                    updateCurve()


                }
            }
        }

        Rectangle{
            id: point2
            width: 12
            height: 12
            radius: 6
            color: "blue"
            border.color: "lightgray"
            x: 100
            y: 100
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                enabled: true
                drag.target: point2
                drag.axis: Drag.XandYAxis
                onReleased: {
//                    p2x = point2.x
//                    p2y = point2.y

//                    if(snaptogrid){
//                        p2x = snapToGridX(point2.x)
//                        p2y = snapToGridY(point2.y)
//                    }

//                     console.log( "-------------- " )
//                    console.log( "point2 y: " +point2.y )

//                    console.log( "point2 y grid: " + convertYToGrid( point2.y+2.5) )

//                     console.log( "-------------- " )
                   updateCurve()
//                    alpha = calc.alphaAngle(convertYToGrid( point1.y+2.5 ), convertXToGrid( point1.x+2.5 ), convertYToGrid( point2.y+2.5 ), convertXToGrid( point2.x+2.5 ))

                }
            }
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


    // Text for current position of points
    Column{
        anchors.left: timerrect.right
        anchors.leftMargin: 30
        anchors.top: timerrect.top

        Text {
            id: pos1text
            text: "P1:   " + "X: " + point1.x + " Y: " + point1.y
            font.pointSize: 12
            color: "green"
        }

        Text {
            id: pos2text
            text: "P2:   " + "X: " + point2.x + " Y: " + point2.y
            font.pointSize: 12
            color: "blue"
        }
    }


}
