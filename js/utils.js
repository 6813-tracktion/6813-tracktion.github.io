
///// UTILS ///////////////////////////////////////////////////////////////

function dayFormat(m) {
    return moment(m).format('YYYY-MM-DD'); // e.g. 2015-02-15
};
function weekFormat(m) {
    // TODO: Let the user change the current goal cycle without affecting
    // past goal periods.  Can probably wait for GR5.
    return moment(m).format('GGGG-[W]WW-1'); // e.g. 2015-W07-1
};

// from http://stackoverflow.com/a/901144/1153180
function getUrlParameter(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

// based on http://codepen.io/recursiev/pen/zpJxs
// only tested on svg elements
function getElementAbsPosition(element) {
	var matrix = element.getScreenCTM()
            .translate(+element.getAttribute("cx"),
                     +element.getAttribute("cy"));
    return {'x': window.pageXOffset + matrix.e,
    	'y': window.pageYOffset + matrix.f}
}

function moveToAbsPosition(sel, x, y) {
	$(sel).css("left", x + "px")
        .css("top", y + "px");
}

function moveToElementPlusOffset(sel, element, dx, dy) {
	pos = getElementAbsPosition(element);
	moveToAbsPosition(sel, pos.x + dx, pos.y + dy);
}

// moment.js can't format() durations, so just do it ourselves; also lets
// us handle 0 or negative durations however we want
function formatDuration(duration, negativeString) {
    if (duration <= 0) {
		return arguments.length > 1 ? negativeString : '0:00';
    }
    var hours = Math.floor(duration / 60);
    var minutes = duration % 60;

    // want 1:00, not 1:0
    if (minutes < 10) {
		return hours + ':0' + minutes;
    }
    return hours + ':' + minutes;
}

function parseDuration(durationString) {
    var tokens = durationString.split(':');
    return parseInt(tokens[tokens.length - 1] || 0, 10) + 60 * parseInt(tokens[tokens.length - 2] || 0, 10);
}
