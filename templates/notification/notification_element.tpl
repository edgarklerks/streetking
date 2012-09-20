<div style="padding:5px 0 5px 0; border-bottom: 1px dotted #f00;" >
	<div style="text-align:left;">
		<b>title:</b> [:title] 
		[:when (read == false)] { <span style="color:#f00;font-size:8px;">new</span> }
	</div>
	<div style="text-align:right;">
		<!--<b>message:</b> [:message] -->
		<a href="#User/notificationSearch?id=[:id]" class="button" module="SHOW_NOTIFICATION">Show</a> 
		[:when (read == false)] {<a href="#User/notificationRead?id=[:id]" class="button" module="READ_NOTIFICATION">Mark as read</a> }
		<a href="#User/archiveNotification?id=[:id]" class="button" module="DELETE_NOTIFICATION">delete</a>
	</div>
</div>