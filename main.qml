import QtQuick
import QtQuick.Controls
import Qt.labs.settings

import ClassCalcCurve 1.0

Window {
    id: root
    width: 680
    height: 700
    visible: true
    title: qsTr("FMathCurve")
    color: "#FFFDD0"

    CalcCurve{  id: calc }


    property bool snaptogrid: false
    property bool showcoordinate: false

    property int p1x: getXAchse(2)
    property int p1y: getYAchse(4)
    property int p2x: getXAchse(6)
    property int p2y: getYAchse(7)
    property int pointmargin: 6


    // Function properties
    property real angle: 0


    // timer values
    property int seconds: 0
    property int maxseconds: 25
    property int milliseconds: 0


    // Returns the y value
    function getYValue(ypix){

        ypix = ypix + 1
        var ya = graph.height / 10
        //var y0 = getYAchse(0)
        var yh = ya * 10
        var yv = (ypix - yh) / ya + 1

        return -yv.toFixed(1)
    }

    function getXValue(xpix){

        var xa = graph.width / 10
        var xv = xpix / xa - 1

        return xv.toFixed(1)

    }

    // Umrechnung von grid zu pixel
    function getXAchse(n){

        var a = graph.width/10
        var xp = n * a + a - 3
        return xp
    }

    function getYAchse(n){

        var a = graph.height/10
        var yp =  graph.height - n * a - a
        return yp - 3
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
            width: 108
            contentItem: Text {
                id: boxtext
                text: qsTr("Snap to grid")
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 10
                font.letterSpacing: 1.5
            }

            onClicked: { snap.checked ? snaptogrid = true : snaptogrid = false  }
        }

        CheckBox{
            id: coord
            text: qsTr("Show coordinate")
            height: row.height
            width: 138
            contentItem: Text {
                id: coortext
                text: qsTr("Show coordinate")
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 10
                font.letterSpacing: 1.5
            }

            onClicked: { coord.checked ? showcoordinate = true : showcoordinate = false  }
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


            // Text y - value
            Text {
                id: yvalueText
                text: qsTr("Y-Value: ") + getYValue(mpoint.y+mpoint.height/2)
                color: "magenta"
                font.pointSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }

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
                startX: p1x+pointmargin ; startY: p1y+pointmargin

                PathLine { x: p2x+pointmargin ; y: p2y+pointmargin }


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
            x: getXAchse(5)-2
            y: getYAchse(3)-2
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                enabled: true
                drag.target: mpoint
                drag.axis: Drag.XandYAxis
                onReleased: {



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
            Text {
                id: coordP1
                visible: showcoordinate
                text: qsTr("P(") + getXValue(p1x+3.5) + "|" + getYValue(p1y+3.5) + ")"
                x:0; y: -15
                font.pointSize: 11
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                enabled: true
                drag.target: point1
                drag.axis: Drag.XandYAxis
                onReleased: {
                    p1x = point1.x
                    p1y = point1.y

                    if(snaptogrid){
                        p1x = snapToGridX(point1.x)
                        p1y = snapToGridY(point1.y)
                    }

                    angle = calc.getAngle(Qt.point(p1x, p1y), Qt.point(p2x, p2y)).toFixed(2)

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
            Text {
                id: coordP2
                visible: showcoordinate
                text: qsTr("P(") + getXValue(p2x+3.5) + "|" + getYValue(p2y+3.5) + ")"
                x:0; y: -15
                font.pointSize: 11
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                enabled: true
                drag.target: point2
                drag.axis: Drag.XandYAxis
                onReleased: {

                    p2x = point2.x
                    p2y = point2.y

                    if(snaptogrid){
                        p2x = snapToGridX(point2.x )
                        p2y = snapToGridY(point2.y )
                    }

                    angle = calc.getAngle(Qt.point(p1x, p1y), Qt.point(p2x, p2y)).toFixed(2)

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
            color: fillrect.width >= timerrect.width/2-timertext.width ? "white" : "green"
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

        Text {
            id: angletext
            text: "Angle: " + angle + "°"
            font.pointSize: 12
            color: "magenta"
        }
    }

    // Save settings befor close
    Settings{
        property alias snapgrid: root.snaptogrid
        property alias showc: root.showcoordinate
    }


    Component.onCompleted: {

        angle = calc.getAngle(Qt.point(p1x, p1y), Qt.point(p2x, p2y)).toFixed(2)

        snaptogrid ? snap.checked = true : snap.checked = false
        showcoordinate ? coord.checked = true : coord.checked = false



    }

}
