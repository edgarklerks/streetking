<div  style='background-image:url({{= Config.imageUrl("user_car",sk.id,"car")}})'>&nbsp;</div>
<div >
	<div >
		<div >
			<div>Manufacturer:&nbsp;<span>{{=sk.manufacturer_name}}</span></div>
			<div>Model:&nbsp;<span>{{=sk.name}}</span></div>
			<div>Year:&nbsp;<span>{{=sk.year}}</span></div>
			<div>Level:&nbsp;<span>{{=sk.level}}</span></div>
		</div>
		<div ></div>
		<div >
			<div >
				<div >Top speed <span>{{=sk.top_speed_values.text}}</span> km/h</div>
				<div >
					<div  style="width:{{=sk.top_speed_values.bar}}%"></div>
				</div>
			</div>
			<div >
				<div >Acceleration <span>{{=sk.acceleration_values.text}}</span> s</div>
				<div >
					<div  style="width:{{=sk.acceleration_values.bar}}%"></div>
				</div>
			</div>
			<div >
				<div >Braking <span>{{=sk.stopping_values.text}}</span> m</div>
				<div >
					<div  style="width:{{=sk.stopping_values.bar}}%"></div>
				</div>
			</div>
			<div >
				<div >Handling <span>{{=sk.cornering_values.text}}</span> g</div>
				<div >
					<div  style="width:{{=sk.cornering_values.bar}}%"></div>
				</div>
			</div>
			<div >
				<div >Weight <span>{{=sk.weight_values.text}}</span> kg</div>
				<div >
					<div  style="width:{{=sk.weight_values.bar}}%"></div>
				</div>
			</div>
			<div >
				<div >Used <span>{{= Math.floor(sk.wear/100)}}</span> %</div>
				<div >
					<div  style="width:{{=Math.floor(sk.wear/100)}}%"></div>
				</div>
			</div>
		</div>
		<a href="#Tournament/join?tournament_id={{=sk.requestParams.tournament_id}}&car_instance_id={{=sk.id}}" class="button" module="EVENTS_TOURNAMENT_JOIN">join</a>
		<div class="clearfix"></div>
	</div>
</div>
<div ></div>