const pages = ["home", "leveringen", "skillpoints", "leaderboard", "bank"];

function showPage(pageName) {
    pages.forEach(p => {
        document.querySelectorAll(`.${p}`).forEach(el => el.style.display = "none");
    });

    document.querySelectorAll(`.${pageName}`).forEach(el => el.style.display = "block");
    document.getElementById("titel").innerText = pageName.toUpperCase() + " PAGINA";
    document.querySelectorAll(".bar button").forEach(btn => btn.classList.remove("active"));
    
    const activeBtn = document.querySelector(`.${pageName}Button`);
    if (activeBtn) activeBtn.classList.add("active");
}

function gotoHome() { showPage("home"); }
function gotoLeveringen() { showPage("leveringen"); }

function sluiten() {
    document.querySelector(".container").style.display = "none";

    fetch(`https://${GetParentResourceName()}/close`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({})
    });
}

function startLevering() {
    fetch(`https://${GetParentResourceName()}/startLevering`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({})
    });
    sluiten()
}

function eindigLevering() {
    fetch(`https://${GetParentResourceName()}/stopLevering`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({})
    });
    sluiten()
}

window.addEventListener("message", function(event) {
    if (event.data.action === "open") {
        document.querySelector(".container").style.display = "block";
        showPage("home");
        document.getElementById("GeldIndicator").innerText = `€ ${event.data.verdientGeld}`
        document.getElementById("RittenIndicator").innerText = `${event.data.geredenRitten}`
        document.getElementById("XPIndicator").innerText = `${event.data.xp}`
        document.getElementById("LevelIndicator").innerText = `${event.data.level}`
        if (event.data.heeftBestelling === true) {
            document.getElementById("beheerLevering").style.display = "flex";
        } else {
            document.getElementById("beheerLevering").style.display = "none";
        }
    }
    if (event.data.action === "close") {
        sluiten()
    }
});

document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") {
        sluiten();
    }
});

window.addEventListener("DOMContentLoaded", () => {
    showPage("home");
});
