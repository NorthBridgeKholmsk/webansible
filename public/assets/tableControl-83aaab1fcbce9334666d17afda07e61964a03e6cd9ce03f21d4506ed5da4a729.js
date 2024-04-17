function del(){
    let csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    let selectedRows = document.getElementsByClassName("checked");
    let logins = [];
    for (let i = 0; i < selectedRows.length; i++) {
        let login = selectedRows[i].parentElement.nextElementSibling.children[0].innerHTML
        //fetch("/users/"+login, {
        //    method: "GET",
        //    headers: {
        //        'X-CSRF-TOKEN': csrfToken
        //    }
        //});
        logins[i] = login
    }
    window.location.href = "/users/"+logins;
};
