import consumer from "../../javascript/channels/consumer";


consumer.subscriptions.create("ChatChannel", {
    connected() {
        console.log("connected")
    },
    received(data) {
        document.getElementById("text").innerText = data["body"]
    }
});
