
///// UTILS ///////////////////////////////////////////////////////////////

function dayFormat(m) {
    return moment(m).format('YYYY-MM-DD'); // e.g. 2015-02-15
};
function weekFormat(m) {
    // TODO: Let the user change the current goal cycle without affecting
    // past goal periods.  Can probably wait for GR5.
    return moment(m).format('GGGG-[W]WW'); // e.g. 2015-W7
};

function getUrlParameter(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
