<div class="car-showroom-element-box" car_id="[:id]" image="[:when (manufacturer_name == "BMW")]{car_1.jpg}[:when (manufacturer_name != "BMW")]{car_2.jpg}">
	<div class="car-showroom-element-info-box">
		<div class="car-showroom-element-info-container">
			<div class="car-showroom-manufacture-box">
				<div class="car-showroom-manufacture-logo-box ui-corner-all">
					<div class="car-showroom-manufacture-logo-box-image normal ui-corner-all" style="background-image:url(images/manufacturers/[:manufacturer_name]_logo.png);"></div>
					<div class="car-showroom-manufacture-box-overlay ui-corner-all"></div>
				</div>
				<div class="car-showroom-manufacture-name-box">
					<div class="car-showroom-manufacture-name">[:manufacturer_name]</div>
					<div class="car-showroom-model-name">[:name]</div>
				</div>
			</div>
			<div class="car-showroom-element-data-info-box">
				<div class="big-element-info-data-box">
					<div class="big-element-info-data-name">Top speed <span>[:top_speed]</span> <b>km/h</b></div>
					<div class="progress-bar-box-small ui-corner-all-2px">
						<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((top_speed/100)*100)]%"></div>
					</div>
				</div>
				<div class="big-element-info-data-box">
					<div class="big-element-info-data-name">Acceleration <span>[:acceleration]</span> <b>s</b></div>
					<div class="progress-bar-box-small ui-corner-all-2px">
						<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((acceleration/100)*100)]%"></div>
					</div>
				</div>
				<div class="big-element-info-data-box">
					<div class="big-element-info-data-name">Braking <span>[:braking]</span></div>
					<div class="progress-bar-box-small ui-corner-all-2px">
						<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((braking/100)*100)]%"></div>
					</div>
				</div>
				<div class="big-element-info-data-box">
					<div class="big-element-info-data-name">Handling <span>[:handling]</span></div>
					<div class="progress-bar-box-small ui-corner-all-2px">
						<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((handling/100)*100)]%"></div>
					</div>
				</div>
				<div class="big-element-info-data-box">
					<div class="big-element-info-data-name">Weight <span>[:weight]</span> <b>kg</b></div>
					<div class="progress-bar-box-small ui-corner-all-2px">
						<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((weight/100)*100)]%"></div>
					</div>
				</div>
				<div class="big-element-info-data-box">
					<div class="big-element-info-data-name">Improve <span>[:improvement]</span> <b>%</b></div>
					<div class="progress-bar-box-small ui-corner-all-2px">
						<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval floor(improvement/1000)]%"></div>
					</div>
				</div>
				<div class="big-element-info-data-box">
					<div class="big-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> <b>%</b></div>
					<div class="progress-bar-box-small ui-corner-all-2px">
						<div class="progress-bar-small progress-bar-small-used ui-corner-all-2px" style="width:[:eval floor(wear/1000)]%"></div>
					</div>
				</div>
			</div>
			<div class="car-showroom-element-buttons-box button-box-wider">
				<div class="car-showroom-element-button-active button-box-nowider">
					[:when (active == false)]{
						[:when (ready == true)]{<a href="#Car/activate?id=[:id]" class="car-button" module="GARAGE_CAR_SET_ACTIVE">set active</a>}
						[:when (ready == false)]{<a href="#Garage/carReady?id=[:id]" class="car-button" module="GARAGE_CAR_SET_ACTIVE_FAIL">set active</a>}
					}
				</div>
				<div class="car-showroom-element-button-action">
					[:when (wear > 0 )]{<a href="#Garage/car?car_instance_id=[:id]" class="car-button cmd-repair [:when (wear > 0 & (active == false))]{cmd-width48}[:when (wear > 0 & (active == true))]{cmd-width100}" module="GARAGE_TASK">repair<div>&nbsp;</div></a>}
					[:when (active == false)]{<a href="#Garage/car?car_instance_id=[:id]" class="car-button [:when (wear > 0 & (active == false))]{cmd-width48}[:when (wear < 1 & (active == false))]{cmd-width100}" module="GARAGE_CAR_SELL">sell<div>&nbsp;</div></a>}
				</div>
				<div class="car-showroom-element-button-info button-box-nowider">
					<a href="#Garage/car?car_instance_id=[:id]&car_id=[:car_id]" class="car-button setup-button" module="GARAGE_CAR_SETUP">set up</a>
					<a href="#Garage/car?car_instance_id=[:id]" class="car-button carinfo-button" module="GARAGE_CAR_INFO">info</a>
				</div>
			</div>
		</div>
	</div>
</div>