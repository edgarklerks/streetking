<div class="{{? skUser.getKey('level') >= sk.track_level }} race_select_track {{??}} race_select_track_locked {{?}}" track_id="{{=sk.track_id}}">
	<div style='border: 1px solid #f00; background-image:url({{= Config.imageUrl("track",sk.track_id,"track")}})'>
		<span>{{=sk.track_name}}</span>
		{{? skUser.getKey('level') < sk.track_level }}
			<span>from<br>level<br><span>{{=sk.track_level}}</span></span>
		{{?}}
	</div>
</div>