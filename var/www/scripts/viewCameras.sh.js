
setInterval(refreshCameras,1000);

function refreshCameras() {
	$("#viewCameras li").each(function(){
		var camid = $(this).prop("id");
		var source = "/data/" + camid + ".jpg?timestamp" + new Date().getTime();
		$(this).find("img").prop("src",source);
	});
}
$(function(){
	$("#viewCameras li").each(function(){
		var camid = $(this).prop("id");
		$(this).find("a").prepend("<img id='" + camid + "_cam' src='/data/"+ camid +".jpg'/>");
	});
});
