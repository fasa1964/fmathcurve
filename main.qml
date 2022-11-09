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
    property bool showformula: false
    property bool animation: false
    property bool hkcurve: false

    property int p1x: getXAchse(2)
    property int p1y: getYAchse(4)
    property int p2x: getXAchse(6)
    property int p2y: getYAchse(7)
    property int pointmargin: 6

    property int crossX: getXAchse(5)
    property int crossY: getYAchse(5)

    // Linear Function values
    property int xPos: 0
    property int b: 0
    property int m: 0

    // Test form values
    property real xn: 0
    property real bn: 0
    property real mn: 0
    property real yn: 0

    // Function properties
    property real angle: 0


    // timer values
    property int seconds: 0
    property int maxseconds: 15
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

    // Points values to get the middle point

    // Gleichungen
    function linearFunction(x,m,b){

        // f(x) = mx + b

        // m = steigung
        // x = x-Wert
        // b = y-Achsenabschnitt
        // f(x) = y - Wert
        //var m = steigung()
        //var x = getXValue( mpoint.x )
        //var b = yAchsenabschnitt()

        var fx = m * x + b


        return fx
    }

    function steigung(){

        var m = 0.0

        // steigung von p1 zu p2
        var X1 = getXValue(point1.x + 3.5)
        var X2 = getXValue(point2.x + 3.5)
        var Y1 = getYValue(point1.y + 3.5)
        var Y2 = getYValue(point2.y + 3.5)

        m = (Y2 - Y1) / (X2 - X1)

        return m.toFixed(2)

    }

    function getAlpha(){

        var X1 = getXValue(point1.x + 3.5)
        var X2 = getXValue(point2.x + 3.5)
        var Y1 = getYValue(point1.y + 3.5)
        var Y2 = getYValue(point2.y + 3.5)

//        var gamma = 90.0

//        var a = (Y2 - Y1) * (graph.width/10)
//        var c = (X2 - X1) * (graph.height/10)

//        var bq = Math.pow(a,2) +  Math.pow(c,2)
//        var b = Math.sqrt(bq)

        var aangle = Math.atan2(Y2-Y1,X2-X1) * 180 / Math.PI

        return aangle.toFixed(2)

    }

    function yAchsenAbschnitt(){

        var st = steigung()
        var Y1 = getYValue(point1.y + 3.5)

        // f(x) = mx + b * y   x = 0
        var yx = st * getXValue(point1.x + 3.5) * 51.2 + (point1.y + 3.5)
        var ya = getYValue(yx)

        // Set cross to position
        crossY = yx
        crossX = getXAchse(0)

        return ya
    }

    function timerTriggered(){

        xPos += 5.12 //5.21
        mn = steigung()
        xn = getXValue( xPos )
        bn = yAchsenAbschnitt()
        yn = linearFunction( xn , mn, bn )


        // Umrechnung des Y-Wertes
        var ynpos = getYAchse(yn)

        mpoint.x = xPos
        mpoint.y = ynpos

        milliseconds++

        if(milliseconds >= 10){
            seconds++
            milliseconds = 0
        }

        if(seconds >= maxseconds  || mpoint.x >= point2.x){
            timer.stop()
            animation = false
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
        spacing: 15
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

                if(!animation){
                    xPos = crossX //  getXAchse(0) // p1x
                    b = yAchsenAbschnitt()
                    m = steigung()
                    mpoint.x = crossX // p1x
                    mpoint.y = crossY // p1y

                }

                animation = true
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

        CheckBox{
            id: form
            text: qsTr("Show formula")
            height: row.height
            width: 115
            contentItem: Text {
                id: formtext
                text: qsTr("Show formula")
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 10
                font.letterSpacing: 1.5
            }

            onClicked: { form.checked ? showformula = true : showformula = false  }
        }
        CheckBox{
            id: hk
            text: qsTr("HK-Curve")
            height: row.height
            width: 85
            contentItem: Text {
                id: hktext
                text: qsTr("HK-Curve")
                horizontalAlignment: Qt.AlignRight
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 10
                font.letterSpacing: 1.5
            }

            onClicked: { hk.checked ? hkcurve = true : hkcurve = false  }
        }

    }

    Row{
        id: row2
        spacing: 20
        anchors.left: graphrect.left
        anchors.bottom: graphrect.top
        visible: showformula
        Text {
            id: formname
            text: qsTr("f(x) = mx + b")
            color: "magenta"
            font.pointSize: 15
        }
        Text {
            id: formvalue
            text: "Y" + " = " + steigung() + " x " + getXValue(mpoint.x) + " + " + yAchsenAbschnitt() //yAchsenabschnitt()
            color: "green"
            font.pointSize: 15
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
            source: hkcurve ? "/svg/HKCurve.svg" : "/svg/graph.svg"
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

        Image {
            id: cross
            source: "/svg/cross.svg"
            width: 12
            height: 12
            x: crossX
            y: crossY

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

                    angle = getAlpha()

                    updateCurve()
                    yAchsenAbschnitt()

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

                    angle = getAlpha()

                    updateCurve()
                    //yAchsenabschnitt()
                    yAchsenAbschnitt()
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
        id: column
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

        Row{
            id: row3
            spacing: 20
            Text {
                id: angletext
                text: "Angle: " + angle + "°"
                font.pointSize: 12
                color: "magenta"
            }
            Text {
                id: mtext
                text: "Steigung [m]: " + steigung()
                font.pointSize: 12
                color: "magenta"
            }
        }
    }

    // Save settings befor close
    Settings{
        property alias snapgrid: root.snaptogrid
        property alias coord: root.showcoordinate
        property alias formula: root.showformula
    }


    Component.onCompleted: {

        angle = getAlpha()

        snaptogrid ? snap.checked = true : snap.checked = false
        showcoordinate ? coord.checked = true : coord.checked = false
        showformula ? form.checked = true : form.checked = false


    }

}
