let nav = document.getElementById("hamburgerMenuArea");
let btn = document.getElementById("hamburgerMenuBtn");
let mask = document.getElementById("mask");
let bar = document.querySelector(".bl_searchBarArea");
let addressBtn = document.getElementById("addressSearchBtn");
let tagBtn = document.getElementById("tagSearchBtn");
let cameraBtn = document.getElementById("cameraSearchBtn");
let returnBtns = document.querySelectorAll(".returnBtn");

const switchingBar = () => {
  nav.classList.toggle("open");
};
const closeSearchBar = () => {
  bar.classList.remove("display_address", "display_camera", "display_tag");
};

btn.addEventListener("click", () => {
  switchingBar();
  closeSearchBar();
});

mask.addEventListener("click", () => {
  switchingBar();
  closeSearchBar();
});

addressBtn.addEventListener("click", () => {
  bar.classList.add("display_address");
});

cameraBtn.addEventListener("click", () => {
  bar.classList.add("display_camera");
});

tagBtn.addEventListener("click", () => {
  bar.classList.add("display_tag");
});

returnBtns.forEach((btn) => {
  btn.addEventListener("click", () => {
    closeSearchBar();
  });
});
