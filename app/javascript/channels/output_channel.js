import consumer from "./consumer"

consumer.subscriptions.create("OutputChannel", {
  connected() {
    console.log("connected")
  },
  received(data) {
    document.getElementById("text").rows += 1
    document.getElementById("text").value += data
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  }
});
