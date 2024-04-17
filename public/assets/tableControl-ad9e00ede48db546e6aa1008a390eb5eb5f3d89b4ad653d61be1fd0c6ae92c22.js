function del(path){
    let selectedRows = document.getElementsByClassName("checked");
    let ids = [];
    for (let i = 0; i < selectedRows.length; i++) {
        let id = selectedRows[i].parentElement.nextElementSibling.children[0].innerHTML
        ids[i] = id
    }
    window.location.href = path+ids;
}
function deltest(path){
    let selectedRows = document.getElementsByClassName("checked");
    let ids = [];
    for (let i = 0; i < selectedRows.length; i++) {
        let id = selectedRows[i].parentElement.nextElementSibling.children[0].innerHTML
        ids[i] = id
        selectedRows[i].parentElement.parentElement.remove();
        i--;
    }
    fetch(path+ids, {
        method: "DELETE",
        headers: {
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        }
    });
    for (let i = 0; i < selectedRows.length; i++) {
        selectedRows[i].parentElement.parentElement.remove();
        i--;
    }
};
