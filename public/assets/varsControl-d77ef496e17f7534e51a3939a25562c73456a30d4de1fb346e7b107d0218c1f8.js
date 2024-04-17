function addVar(){
    const btn_addVar = document.getElementById("btn_addVar");
    const newVar = document.getElementById("newVar").cloneNode(true);
    newVar.id = "";
    newVar.classList.remove("visually-hidden");
    document.getElementById("vars").insertBefore(newVar, btn_addVar);
}

function delVar(e){
    e.parentElement.parentElement.remove();
};
