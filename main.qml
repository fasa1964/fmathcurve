import QtQuick
import QtQuick.Controls
import Qt.labs.settings

import ClassCalcCurve 1.0

Window {
    id: root
    width: 500
    height: 659
    visible: true
    title: qsTr("FMathCurve")
    color: "#FFFDD0"

    CalcCurve{  id: calc }

    property bool android: false

    property bool snaptogridy: false
    property bool snaptogridx: false
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

    // Test caculate textsize
    property real textsize: android ? root.width/35 : root.width/50


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
        var yx = st * getXValue(point1.x + 3.5) *  (graph.width/10)   /*51.2*/ + (point1.y + 3.5)
        var ya = getYValue(yx)

        // Set cross to position
        crossY = yx
        crossX = getXAchse(0)

        return ya
    }

    function timerTriggered(){

        xPos += mpoint.width/2 //5.12 //5.21
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

//        if(seconds >= maxseconds  || mpoint.x+mpoint.width/2 >= point2.x+point2.width/2){
//            timer.stop()
//            animation = false
//            milliseconds = 0
//            seconds = 0
//        }
        if(seconds >= maxseconds  ||  yn > getYValue(point2.y+point2.height/2-6) ){
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

    Flow{
        id: topflow
        width: root.width - 20
        x:10
        y:10
        spacing: android ? 1 : 10

        CheckBox{
            id: snap
            text: qsTr("Snap to grid")
            onClicked: {

                snap.checked ? snaptogrid = true : snaptogrid = false

                if(snaptogrid){
                    snapx.checked = false
                    snapy.checked = false
                    snaptogridy = false
                    snaptogridx = false
                }

            }
        }

        CheckBox{
            id: snapx
            text: qsTr("Snap to x")
            onClicked: {

                snapx.checked ? snaptogridx = true : snaptogridx = false

                if(snaptogridx){
                    snap.checked = false
                    snapy.checked = false
                    snaptogrid = false
                    snaptogridy = false
                }
            }
        }

        CheckBox{
            id: snapy
            text: qsTr("Snap to y")

            onClicked: {

                snapy.checked ? snaptogridy = true : snaptogridy = false

                if(snaptogridy){
                    snap.checked = false
                    snapx.checked = false
                    snaptogrid = false
                    snaptogridx = false
                }
            }
        }

        CheckBox{
            id: coord
            text: qsTr("Show coordinate")

            onClicked: { coord.checked ? showcoordinate = true : showcoordinate = false  }
        }

        CheckBox{
            id: form
            text: qsTr("Show formula")

            onClicked: { form.checked ? showformula = true : showformula = false  }
        }

        CheckBox{
            id: hk
            text: qsTr("HK-Curve")
//            height: 28
//            width: 95
//            contentItem: Text {
//                id: hktext
//                text: qsTr("HK-Curve") + hk.width
//                horizontalAlignment: Qt.AlignRight
//                verticalAlignment: Qt.AlignVCenter
//                font.pointSize: 10
//                font.letterSpacing: 1.5
//            }

            onClicked: { hk.checked ? hkcurve = true : hkcurve = false  }
        }
    }


    // Image
    Rectangle{
        id: graphrect
        width:  root.width-40 // 514
        height: graphrect.width // 514
        x:20
        anchors.top: topflow.bottom
        anchors.topMargin: 20

        color: "transparent"
        border.color: "magenta"

        Button{
            id: startbutton
            text: "Start"
            width: android ? 60 : root.width/11 //  60
            height: android ? 30 :  startbutton.width/2 //  30
            z:2
            anchors.right: parent.right
            contentItem: Text {
                id: text
                text: timer.running ? qsTr("Pause") : qsTr("Start")
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: android ? 11 : textsize
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


        Image {
            id: graph
            source: hkcurve ? "/svg/HKCurve.svg" : "/svg/graph.svg"
            width: graphrect.width-2      //  512
            height: graphrect.height    //  512
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent


            // Text y - value
            Text {
                id: yvalueText
                text:  hkcurve ? "VT: " + calc.getVorlaufTemperatur(  getYValue(mpoint.y+mpoint.height/2) ) + " °C" :  qsTr("Y-Value: ") + getYValue(mpoint.y+mpoint.height/2)
                color: "magenta"
                font.pointSize: textsize+3
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
            width: android ? 12 : graph.width/46
            height: mpoint.width
            radius: android ? 6 : mpoint.width/2
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
            width: android ? 12 : graph.width/38 // 12
            height: point1.width
            radius: point1.width/2
            color: "green"
            border.color: "lightgray"
            x: p1x
            y: p1y
            Text {
                id: coordP1
                visible: showcoordinate
                text: qsTr("P(") + getXValue(p1x+point1.width/2-1) + "|" + getYValue(p1y+3.5) + ")"
                x:0; y: point1.height
                font.pointSize: textsize-1
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
                        p1x = snapToGridX(point1.x + point1.width/2)
                        p1y = snapToGridY(point1.y)
                    }

                    if(snaptogridx)
                        p1x = snapToGridX(point1.x)

                    if(snaptogridy)
                        p1y = snapToGridY(point1.y)

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
                font.pointSize: textsize-1
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

                    if(snaptogridx)
                        p2x = snapToGridX(point2.x)

                    if(snaptogridy)
                        p2y = snapToGridY(point2.y)

                    angle = getAlpha()

                    updateCurve()
                    //yAchsenabschnitt()
                    yAchsenAbschnitt()
                }
            }
        }
    }

    Flow{
        id: bottomflow
        width: parent.width-40
        anchors.top: graphrect.bottom
        x:20
        spacing: android ? 10 : 20

        // Text for current position of points
        Column{
            id: column
            Text {
                id: pos1text
                text: {

                    if(!hkcurve)
                        "P1:   " + "X: " + point1.x.toFixed(0) + " Y: " + point1.y.toFixed(0)
                    else
                        "P1:   " + "AT: " + calc.getAussenTemperatur( getXValue( point1.x+3.5 ) ) + "°C" + "  VT: " +  calc.getVorlaufTemperatur( getYValue( point1.y+3.5) ) + "°C"

                }
                font.pointSize: android ? 12 : textsize
                color: "green"
            }

            Text {
                id: pos2text
                text:{

                    if(!hkcurve)
                        "P2:   " + "X: " + point2.x + " Y: " + point2.y
                    else
                        "P2:   " + "AT: " + calc.getAussenTemperatur( getXValue( point2.x+3.5 ) ) + "°C" + "  VT: " +  calc.getVorlaufTemperatur( getYValue( point2.y+3.5) ) + "°C"

                }
                font.pointSize: textsize
                color: "blue"
            }

        }

        Column{
            id: column2
            Text {
                id: angletext
                text: "Angle: " + angle + "°"
                font.pointSize: textsize
                color: "magenta"
            }
            Text {
                id: mtext
                text: "Steigung [m]: " + steigung()
                font.pointSize: textsize
                color: "magenta"
            }
        }

        Column{
            id: rowformular
//            spacing: 10
//            anchors.left: graphrect.left
//            anchors.bottom: graphrect.top
            visible: showformula
            Text {
                id: formname
                text: qsTr("f(x) = mx + b")
                color: "magenta"
                font.pointSize: textsize
            }
            Text {
                id: formvalue
                text: "Y" + " = " + steigung() + " x " + getXValue(mpoint.x) + " + " + yAchsenAbschnitt() //yAchsenabschnitt()
                color: "green"
                font.pointSize: textsize
            }
        }
    }





    // Timerrect
    Rectangle{
        id: timerrect
        width: startbutton.width
        height: android ? 18 : startbutton.height
        anchors.right: graphrect.right
        anchors.bottom: graphrect.bottom
        anchors.topMargin: 5
        border.color: "green"
        color: "transparent"
        z:2
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
            color: fillrect.width >= timerrect.width/2 ?  "white" : "green"
        }
    }


    // Save settings befor close
    Settings{
        property alias snapgridy: root.snaptogridy
        property alias snapgridx: root.snaptogridx
        property alias snapgrid: root.snaptogrid
        property alias coord: root.showcoordinate
        property alias formula: root.showformula
    }


    Component.onCompleted: {

        Qt.platform.os === "android" ? android = true : android = false


        angle = getAlpha()

        snaptogrid ? snap.checked = true : snap.checked = false
        snaptogridx ? snapx.checked = true : snapx.checked = false
        snaptogridy ? snapy.checked = true : snapy.checked = false
        showcoordinate ? coord.checked = true : coord.checked = false
        showformula ? form.checked = true : form.checked = false
    }

}
