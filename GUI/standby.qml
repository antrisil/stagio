import QtQuick
import QtQuick.Controls

Item {
    width: 640
    height: 480
    property bool timeron: false
    signal exitClicked()
    property int a: 0
    property bool b: true

    function updateTime(modelIndex, field, value) {
        var element = myListView.model.get(modelIndex);
        switch (field) {
        case "hours":
            element.hours = value
            if (value < 10) {
                textHours.text = "0" + value + ":"
            } else {
                textHours.text = value + ":"
            }
            idleTimer.setHours(value)
            db.setHours(value)
            db.updateStandby()
            break
        case "minutes":
            element.minutes = value
            if (value < 10) {
                textMinutes.text = "0" + value + ":"
            } else {
                textMinutes.text = value + ":"
            }
            idleTimer.setMinutes(value)
            db.setMinutes(value)
            db.updateStandby()
            break
        case "seconds":
            element.seconds = value
            if (value < 10) {
                textSeconds.text = "0" + value
            } else {
                textSeconds.text = value
            }
            idleTimer.setSeconds(value)
            db.setSeconds(value)
            db.updateStandby()
            break
        }
        myListView.model.set(modelIndex, element)
    }

    Rectangle {
        anchors.fill: parent

        Rectangle {
            id: timer2
            width: parent.width
            height: 50
            color: "#aaaaaa"
            border.color: "black"
            border.width: 1

            Text {
                id: settingtext
                color: "#000000"
                text: "STANDBY"
                font.bold: true
                styleColor: "#000000"
                font.pointSize: 20
                anchors.centerIn: parent
            }
        }

        ListView {

            id: myListView
            width: parent.width
            height: parent.height - 50
            y: 50
            model: ListModel {
                ListElement {
                    name: "Timer"
                    hours: 0
                    minutes: 0
                    seconds: 0
                }
                ListElement {
                    name: "Exit"
                }
            }
            delegate: Rectangle {
                width: myListView.width
                height: myListView.height / 7
                color: ListView.isCurrentItem ? "lightblue" : "white"
                border.color: "black"
                Text {
                    id: test
                    text: name === "Timer" ? "" : name === "Exit" ? qsTr("Exit") : name
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        myListView.currentIndex = index
                        console.log("La opcion seleccionada es:", name);
                    }
                }
            }
        }

        Rectangle {
            id: buttons1
            width: 80
            height: alturaTela - 100
            radius: 10
            border.color: "black"
            border.width: 1
            x: -20;y: 50

            Image {
                id: arrow
                fillMode: Image.PreserveAspectFit
                source: "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
                width: 50
                x: 25;y: 50
                transformOrigin: Item.Center
                rotation: 270
            }

            Image {
                id: startop
                fillMode: Image.PreserveAspectFit
                source: "file:///home/jonathan/Desktop/GUI/imagens/power.png"
                width: 50
                x: 25;y: 290
            }
            Button {
                text: "up"
                x: 25;y: 50
                height: 50
                width: 50
                opacity: 0
                onClicked: {
                    if (timeron === false) {
                        if (myListView.currentIndex >= -1) {
                            myListView.currentIndex--;
                            if (myListView.currentIndex === -1) {
                                myListView.currentIndex = myListView.count - 1
                            }
                        }
                    } else if (timeron && a === 0 && myListView.model.get(myListView.currentIndex).hours > 0) {
                        updateTime(myListView.currentIndex, "hours", (myListView.model.get(myListView.currentIndex).hours - 1) % 60);
                    } else if (timeron && a === 0 && myListView.model.get(myListView.currentIndex).hours === 0) {
                        updateTime(myListView.currentIndex, "hours", (myListView.model.get(myListView.currentIndex).hours = 0) % 60);
                    } else if (timeron && a === 1 && myListView.model.get(myListView.currentIndex).minutes > 0) {
                        updateTime(myListView.currentIndex, "minutes", (myListView.model.get(myListView.currentIndex).minutes - 1) % 60);
                    } else if (timeron && a === 1 && myListView.model.get(myListView.currentIndex).minutes === 0) {
                        updateTime(myListView.currentIndex, "minutes", (myListView.model.get(myListView.currentIndex).minutes = 0) % 60);
                    } else if (timeron && a === 2 && myListView.model.get(myListView.currentIndex).seconds > 0) {
                        updateTime(myListView.currentIndex, "seconds", (myListView.model.get(myListView.currentIndex).seconds - 1) % 60);
                    } else if (timeron && a === 2 && myListView.model.get(myListView.currentIndex).seconds === 0) {
                        updateTime(myListView.currentIndex, "seconds", (myListView.model.get(myListView.currentIndex).seconds = 0) % 60);
                    }
                }
            }
        }

        Rectangle {
            id: buttons2
            width: 80
            height: alturaTela - 100
            radius: 10
            border.color: "black"
            border.width: 1
            x: larguraTela - 60;y: 50

            Image {
                id: arrow2
                fillMode: Image.PreserveAspectFit
                source: "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
                width: 50
                x: 5;y: 50
                transformOrigin: Item.Center
                rotation: 90
            }

            Image {
                id: settingsIcon
                fillMode: Image.PreserveAspectFit
                source: "file:///home/jonathan/Desktop/GUI/imagens/enter.png"
                width: 50
                x: 5;y: 290
            }
            Button {
                id: buttonDown
                text: "down"
                x: 5;y: 50
                height: 50
                width: 50
                opacity: 0
                onClicked: {
                    if (timeron === false) {
                        if (myListView.currentIndex <= myListView.count - 1) {
                            myListView.currentIndex++;
                            if (myListView.currentIndex === myListView.count) {
                                myListView.currentIndex = 0
                            }
                        }
                    } else if (timeron && a === 0) {
                        updateTime(myListView.currentIndex, "hours", (myListView.model.get(myListView.currentIndex).hours + 1) % 60);
                    } else if (timeron && a === 1) {
                        updateTime(myListView.currentIndex, "minutes", (myListView.model.get(myListView.currentIndex).minutes + 1) % 60);
                    } else if (timeron && a === 2) {
                        updateTime(myListView.currentIndex, "seconds", (myListView.model.get(myListView.currentIndex).seconds + 1) % 60);
                    }
                }
            }
            Button {
                text: "Seleccionar"
                width: 50
                height: 50
                x: 5;y: 290
                opacity: 0
                onClicked: {
                    myListView.forceActiveFocus()
                    var optionSelected = myListView.model.get(myListView.currentIndex).name
                    if (myListView.currentItem != null) {
                        console.log("La opcion seleccionada es:", optionSelected)
                        if (optionSelected === "Exit") {
                            onClicked: exitClicked()
                        }
                        else if (optionSelected === "Timer") {
                            if (timeron === false) {
                                timeron = true
                                arrow2.source = "file:///home/jonathan/Desktop/GUI/imagens/plus.png"
                                arrow.source = "file:///home/jonathan/Desktop/GUI/imagens/less.png"
                                arrow.rotation = 0
                                animationHours.running = true
                            } else if (a === 0) {
                                a++
                                animationHours.running = false
                                textHours.opacity = 1
                                animationMinutes.running = true
                            } else if (a === 1) {
                                a++
                                animationMinutes.running = false
                                textMinutes.opacity = 1
                                animationSeconds.running = true
                            } else if (a === 2) {
                                animationSeconds.running = false
                                textSeconds.opacity = 1
                                arrow2.source = "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
                                arrow.source = "file:///home/jonathan/Desktop/GUI/imagens/arrow.jpg"
                                arrow.rotation = 270
                                timeron = false
                                a = 0
                            }
                        }
                    } else {
                        console.log("El valor de la opcion seleccionada no es valido");
                    }
                    if (b) {
                        var element = myListView.model.get(myListView.currentIndex);
                        element.hours = db.getHours
                        element.minutes = db.getMinutes
                        element.seconds = db.getSeconds
                        b = false
                    }
                }
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: myListView.height / 7
            y: 50
            Text {
                text: qsTr("Timer : ")
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: textHours
                text: db.getHours < 10 ? "0" + db.getHours.toString() + ":" : db.getHours.toString() + ":"
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: textMinutes
                text: db.getMinutes < 10 ? "0" + db.getMinutes.toString() + ":" : db.getMinutes.toString() + ":"
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: textSeconds
                text: db.getSeconds < 10 ? "0" + db.getSeconds.toString() : db.getSeconds.toString()
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        SequentialAnimation {
            id: animationHours
            loops: Animation.Infinite

            NumberAnimation {
                target: textHours
                property: "opacity"
                from: 0
                to: 1
                duration: 500
            }

            PauseAnimation {
                duration: 200
            }

            NumberAnimation {
                target: textHours
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
            running: false
        }
        SequentialAnimation {
            id: animationMinutes
            loops: Animation.Infinite

            NumberAnimation {
                target: textMinutes
                property: "opacity"
                from: 0
                to: 1
                duration: 500
            }

            PauseAnimation {
                duration: 200
            }

            NumberAnimation {
                target: textMinutes
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
            running: false
        }
        SequentialAnimation {
            id: animationSeconds
            loops: Animation.Infinite

            NumberAnimation {
                target: textSeconds
                property: "opacity"
                from: 0
                to: 1
                duration: 500
            }

            PauseAnimation {
                duration: 200
            }

            NumberAnimation {
                target: textSeconds
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
            running: false
        }
    }
}
