import QtQuick

Item {
    width: 640
    height: 480
  Rectangle {
    anchors.fill: parent
    color: "black"
  }

  Rectangle {
    id: circle
    width: 250
    height: width
    radius: width / 2
    color: "white"
    border.color: "black"
    border.width: 5
    anchors.centerIn: parent

    Text {
      id: load
      text: qsTr("BOOTING")
      font.pointSize: 20
      anchors.centerIn: parent
    }
  }

  SequentialAnimation {

    loops: Animation.Infinite

    ColorAnimation {
      target: circle
      property: "border.color"
      from: "black"
      to: "blue"
      duration: 1500
    }

    PauseAnimation {
      duration: 1000
    }

    ColorAnimation {
      target: circle
      property: "border.color"
      from: "blue"
      to: "black"
      duration: 1500
    }
    running: true
  }

  SequentialAnimation {

    loops: Animation.Infinite

    ColorAnimation {
      target: load
      property: "color"
      from: "black"
      to: "blue"
      duration: 1500
    }

    PauseAnimation {
      duration: 1000
    }

    ColorAnimation {
      target: load
      property: "color"
      from: "blue"
      to: "black"
      duration: 1500
    }
    running: true
  }

  SequentialAnimation {
    loops: Animation.Infinite
    PropertyAnimation {
      target: circle;
      property: "width";
      to: 260;
      duration: 1500
    }

    PropertyAnimation {
      target: circle
      property: "width"
      to: 250
      duration: 1500
    }

    PauseAnimation {
      duration: 1000
    }
    running: true
  }

  SequentialAnimation {
    loops: Animation.Infinite
    PropertyAnimation {
      target: load;
      property: "font.pointSize";
      to: 22;
      duration: 1500
    }

    PropertyAnimation {
      target: load
      property: "font.pointSize"
      to: 20
      duration: 1500
    }

    PauseAnimation {
      duration: 1000
    }
    running: true
  }

}
