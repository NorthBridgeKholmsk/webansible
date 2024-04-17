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
        document.getElementById("btn-slide-menu").classList.remove("bi-caret-left-fill");
        document.getElementById("btn-slide-menu").classList.add("bi-caret-right-fill");
    }
    else{
        for (let i=0; i < menuSlide.length; i++){
            menuSlide[i].style.display = "none";
        }
        document.getElementById("btn-slide-menu").classList.add("bi-caret-left-fill");
        document.getElementById("btn-slide-menu").classList.remove("bi-caret-right-fill");
    }
}

function clickMenuTurn(){
    menuSlide[0].style.display = "none";
    menuTurn();
};
