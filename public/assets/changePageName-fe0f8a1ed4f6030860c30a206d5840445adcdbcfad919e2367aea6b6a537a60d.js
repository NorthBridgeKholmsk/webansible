document.addEventListener("DOMContentLoaded", function(){
   let navs = document.getElementsByClassName("nav");
   for (let i = 0; i < navs.length; i++){
       let navs_item = navs[i].children;
       alert(navs_item.length);
       for (let j = 0; j < navs_item.length; j++){
           navs_item[i].addEventListener("click", function (){
               alert(navs_item[i].innerHTML);
               document.getElementById("page_name").innerText = navs_item[i].innerHTML
           });
       }
   }
});
