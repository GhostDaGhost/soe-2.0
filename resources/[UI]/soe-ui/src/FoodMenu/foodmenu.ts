const $foodMenu = $('#foodmenu_container');

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let data = event.data
    switch(data.type) {
        case 'FoodMenu.OpenUI':
            OpenFoodMenu(data.imageName);
            break;
    }
})

function CloseFoodMenu() {
    $.post("https://soe-ui/FoodMenu.CloseUI", JSON.stringify({}));
    $foodMenu.animate({top: "-105%"}, 250, () => {
        $foodMenu.css("display", "none");
        $foodMenu.empty();
    })
}

function OpenFoodMenu(imageName: string) {
    $foodMenu.css("display", "block");
    $foodMenu.empty();

    $foodMenu.append(`
        <img id='foodmenu_content' src='img/${imageName}'></img>
    `);
    $foodMenu.animate({top: "5%"}, 650, () => {})
}

$(() => {
    $(document).on('keydown', (event) => {
        switch(event.key) {
            case 'Escape':
                CloseFoodMenu();
                break;
            case 'Tab':
                CloseFoodMenu();
                break;
        }
    });
})
