import QtQuick
import QtQuick.Controls

Item {
    width: 640
    height: 480
    property bool timeron : false
    property bool b: true
    property int a : 0
    property int seconds : db.getSeconds
    property int minutes : db.getMinutes
    property int hours : db.getHours
    signal exitClicked()
    signal outputClicked()
    signal metricsClicked()
    signal bypassClicked()
    signal standbyClicked()
    signal maintenanceClicked()
    signal languagesClicked()
    signal monitorToSettings()

    function updateTime(field, value){

        switch (field) {
        case "hours":
            if (value < 10)
            {
                textHours.text = "0" + value + ":"
            } else
            {
                textHours.text = value + ":"
            }
            hours = value
            idleTimer.setHours(value)
            db.setHours(value)
            db.updateStandby()
            db.selectStandby()
        break
        case "minutes":
            if (value < 10) {
                textMinutes.text = "0" + value + ":"
            } else {
                textMinutes.text = value + ":"
            }
            minutes = value
            idleTimer.setMinutes(value)
            db.setMinutes(value)
            db.updateStandby()
            db.selectStandby()
        break
        case "seconds":
            if (value < 10) {
                textSeconds.text = "0" + value
            } else {
                textSeconds.text = value
            }
            seconds = value
            idleTimer.setSeconds(value)
            db.setSeconds(value)
            db.updateStandby()
            db.selectStandby()
        break
        }
    }

    Rectangle{
        anchors.fill: parent

        Rectangle{
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
                ListElement{
                    name: "Timer"
                }
                ListElement{
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
                source: "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/arrow.jpg"
                width: 50
                x: 25;y: 50
                transformOrigin: Item.Center
                rotation: 270
            }
            Image {
                id: startop
                fillMode: Image.PreserveAspectFit
                source: "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/power.png"
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
                    if(idleTimer.getSleepi() === 0){
                        if (timeron === false) {
                            if (myListView.currentIndex >= -1) {
                                myListView.currentIndex--;
                                if (myListView.currentIndex === -1) {
                                    myListView.currentIndex = myListView.count - 1
                                }
                            }
                        }
                        else if(timeron && a === 0 && hours > 0){
                            updateTime("hours", (hours - 1) % 60);
                        }
                        else if(timeron && a === 0 && hours === 0){
                            updateTime("hours", (hours = 0) % 60);
                        }
                        else if(timeron && a === 1 && minutes > 0){
                            updateTime("minutes", (minutes - 1) % 60);
                        }
                        else if(timeron && a === 1 && minutes === 0){
                            updateTime("minutes", (minutes = 0) % 60);
                        }
                        else if (timeron && a === 2 && seconds > 0) {
                            updateTime("seconds", (seconds - 1) % 60);
                        }
                        else if (timeron && a === 2 && seconds === 0) {
                            updateTime("seconds", (seconds = 0) % 60);
                        }
                    }
                    else{
                        console.log("screen waked")
                        idleTimer.setSleepi(0);
                    }
                }
            }

            Button{
                id: poweroff
                width: arrow.width
                height: arrow.height
                opacity: 0
                x: 25;y: 290
                onClicked:{
                    Qt.quit();
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
                source: "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/arrow.jpg"
                width: 50
                x: 5;y: 50
                transformOrigin: Item.Center
                rotation: 90
            }

            Image {
                id: settingsIcon
                fillMode: Image.PreserveAspectFit
                source: "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/enter.png"
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
                    if(idleTimer.getSleepi() === 0){
                        if (timeron === false) {
                            if (myListView.currentIndex <= myListView.count - 1) {
                                myListView.currentIndex++;
                                if (myListView.currentIndex === myListView.count) {
                                    myListView.currentIndex = 0
                                }
                            }
                        }
                        else if (timeron && a === 0) {
                            updateTime("hours", (hours + 1) % 60);
                        }
                        else if (timeron && a === 1) {
                            updateTime("minutes", (minutes + 1) % 60);
                        }
                        else if (timeron && a === 2) {
                            updateTime("seconds", (seconds + 1) % 60);
                        }
                    }
                    else{
                        console.log("screen waked")
                        idleTimer.setSleepi(0);
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
                    if(idleTimer.getSleepi() === 0){
                        var optionSelected = myListView.model.get(myListView.currentIndex).name
                        if (myListView.currentItem != null) {
                            if (optionSelected === "Exit") {
                                onClicked: exitClicked()
                            }
                            else if (optionSelected === "Timer") {
                                if (timeron === false) {
                                    timeron = true
                                    arrow2.source = "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/plus.png"
                                    arrow.source = "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/less.png"
                                    arrow.rotation = 0
                                    animationHours.running = true
                                }
                                else if (a === 0) {
                                    a++
                                    animationHours.running = false
                                    textHours.opacity = 1
                                    animationMinutes.running = true
                                }
                                else if (a === 1) {
                                    a++
                                    animationMinutes.running = false
                                    textMinutes.opacity = 1
                                    animationSeconds.running = true
                                }
                                else if (a === 2) {
                                    animationSeconds.running = false
                                    textSeconds.opacity = 1
                                    arrow2.source = "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/arrow.jpg"
                                    arrow.source = "file:///home/jonathan/Desktop/Jonathan/GUI/imagens/arrow.jpg"
                                    arrow.rotation = 270
                                    timeron = false
                                    a = 0
                                }
                            }
                        }
                        else {
                        }
                    }
                    else{
                        console.log("screen waked")
                        idleTimer.setSleepi(0);
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
                text: hours < 10 ? "0" + hours.toString() + ":" : hours.toString() + ":"
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: textMinutes
                text: minutes < 10 ? "0" + minutes.toString() + ":" : minutes.toString() + ":"
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                id: textSeconds
                text: seconds < 10 ? "0" + seconds.toString() : seconds.toString()
                anchors.verticalCenter: parent.verticalCenter
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
}
