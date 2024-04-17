var menuSlide = [
    document.getElementById("logo_img"),
    document.getElementById("btn_invent_text"),
    document.getElementById("btn_project_text"),
    document.getElementById("btn_run-playbook_text"),
    document.getElementById("btn_settings_text"),
];

function menuTurn(){
    if (menuSlide[0].style.display === "none"){
        for (let i=0; i < menuSlide.length; i++){
            menuSlide[i].style.removeProperty("display");
        }
    }
    else{
        for (let i=0; i < menuSlide.length; i++){
            menuSlide[i].style.display = "none";
        }
    }
}

function clickMenuTurn(){
    menuSlide[0].style.display = "none";
    menuTurn();
};
