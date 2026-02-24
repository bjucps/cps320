// Function to show the events section and hide the welcome box
function showEvents() {
  document.getElementById("welcome").style.display = "none";
  document.getElementById("events").style.display = "block";
  window.scrollTo({ top: 0, behavior: "smooth" });
}
// Function to show the events section with a fade-out effect for the welcome box
function showEvents() {
  const welcome = document.getElementById("welcome");
  const events = document.getElementById("events");

  // 1. welcome 박스의 opacity를 0으로 (페이드 아웃)
  welcome.style.opacity = 0;

  // 2. 약 0.8초 뒤에 display none 처리
  setTimeout(() => {
    welcome.style.display = "none";

    // 3. events 표시하고 opacity를 1로 (페이드 인)
    events.style.display = "block";
    setTimeout(() => {
      events.style.opacity = 1;
    }, 50);
  }, 800); // transition 속도와 동일하게
}



