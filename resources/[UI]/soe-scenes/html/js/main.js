const $sceneMenu = $('#scenes_container');

// NUI EVENT LISTENER
window.addEventListener('message', (event) => {
    let type = event.data.type
    switch(type) {
        case 'Scenes.ShowUI':
            ShowSceneUI();
            break;
        case 'Scenes.ResetUI':
            CloseSceneUI();
            console.log('[Scenes] UI resetted.');
            break;
        default:
            console.log("Invalid type passed to NUI (" + type + ")");
            break;
    }
});

// SHOWS SCENE UI MANAGEMENT MENU
function ShowSceneUI() {
    $sceneMenu.fadeIn(300);
    $("#scenes_text-input").focus();
}

// CLOSES SCENE UI MANAGEMENT MENU
function CloseSceneUI() {
    $.post("https://soe-scenes/Scenes.CloseUI", JSON.stringify({}));
    $sceneMenu.fadeOut(250);
}

// GENERAL INTERACTION FUNCTION
$(() => {
    // CLOSES UI WHEN 'ESCAPE' IS PRESSED
    $(document).on('keydown', (event) => {
        switch(event.key) {
            case 'Escape':
                CloseSceneUI();
                break;
        }
    });

    // CREATE BUTTON EVENT EXECUTIONS
    $('#scenes_createbutton').on('click', function() {
        let $text_input = $("#scenes_textinput").val();
        let $distance_input = $("#scenes_distanceinput").val();
        let $color_input = $('#scenes_colorchoice').children("option:selected").val();

        CloseSceneUI();
        $.post("https://soe-scenes/Scenes.CreateScene", JSON.stringify({
            text: $text_input,
            color: $color_input,
            distance: $distance_input
        }));

        $('#scenes_textinput').val('');
        $('#scenes_distanceinput').val('');
        $('#scenes_colorchoice').val('White');
    });
})
