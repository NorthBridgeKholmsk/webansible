function addVar(){
    const btn_addVar = document.getElementById("btn_addVar");
    const newVar = document.getElementById("newVar").cloneNode(true);
    newVar.id = "";
    document.getElementById("vars").insertBefore(newVar, btn_addVar);
}

function delVar(){

};