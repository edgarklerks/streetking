<div class="travel-cities-point-box" style="[:city_data]">
	[:when (me.level > (city_level - 1) & me.city_id != city_id)]{
		<a href="#Track/list/?city=[:city_id]&con=[:continent_name]&cin=[:city_name]&cit=[:city_tracks]" alt="" title="" module="TRACK_LIST_BY_CITIES">
			<div class="travel-cities-point" city="[:city_name]" link="#City/travel/?id=[:city_id]">
				<div class="travel-cities-point-inner"></div>
			</div>
		</a>
		<div class="travel-cities-name ui-corner-all">[:city_name]</div>
	}[:when (me.city_id == city_id)]{
		<div class="travel-cities-pointa">
			<div class="travel-cities-point-innera"></div>
		</div>
		<div class="travel-cities-namea ui-corner-all">[:city_name]<br><span>you are here</span></div>
	}
	[:when (me.level < city_level)]{
		<div class="travel-cities-pointd">
			<div class="travel-cities-point-innerd"></div>
		</div>
		<div class="travel-cities-named ui-corner-all">[:city_name]<br><span>from level [:city_level]</span></div>
	}
</div>