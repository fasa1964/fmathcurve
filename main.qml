import QtQuick
import QtQuick.Controls

Window {
    width: 680
    height: 680
    visible: true
    title: qsTr("FMathCurve")
    color: "#FFFDD0"


    property bool snaptogrid: false
    property int p1x: getXAchse(2)
    property int p1y: getYAchse(4)
    property int p2x: getXAchse(6)
    property int p2y: getYAchse(7)


    // timer values
    property int seconds: 0
    property int maxseconds: 25
    property int milliseconds: 0


    // Umrechnung von grid zu pixel
    function getXAchse(n){

        var a = graph.width/10
        var xp = n * a + a
        return xp
    }

    function getYAchse(n){

        var a = graph.height/10
        var yp =  graph.height - n * a - a
        return yp
    }
    // !-----------------------------


    // Snap to nearest grid
    function snapToGridX(x){

        var aw = graph.width / 10     // = 51.2
        var xp = (x / aw).toFixed(0) - 1
        xp = getXAchse(xp)

        return xp;
    }

    function snapToGridY(y){

        var ah = graph.height / 10     // = 51.2
        var y0 = getYAchse(0)
        var yp = ((y0 - y) / ah).toFixed(0)
        yp = getYAchse(yp)

        return yp;
    }
    // !------------------------------





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
            source: "/svg/graph.svg"
            width: 512
            height: 512
            fillMode: Image.PreserveAspectFit
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
                startX: p1x ; startY: p1y

                PathLine { x: p2x ; y: p2y }


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
            x: p1x
            y: p1y
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                enabled: true
                drag.target: point1
                drag.axis: Drag.XandYAxis
                onReleased: {
                    p1x = point1.x + 6
                    p1y = point1.y + 6

                    if(snaptogrid){
                        p1x = snapToGridX(point1.x + 6)
                        p1y = snapToGridY(point1.y + 6)
                    }

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
            x: p2x
            y: p2y
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                enabled: true
                drag.target: point2
                drag.axis: Drag.XandYAxis
                onReleased: {

                    p2x = point1.x + 6
                    p2y = point2.y + 6

                    if(snaptogrid){
                        p2x = snapToGridX(point2.x + 6)
                        p2y = snapToGridY(point2.y + 6)
                    }

                   updateCurve()


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
