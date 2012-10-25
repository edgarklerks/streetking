<li class="garage-car-showroom-element-container" style="background-image:url([:eval IMAGESERVER("[\"user_car\","+id+",\"car\"]")])">
	<div class="garage-car-showroom-element-info-container corner-box">
		<div class="garage-car-showroom-element-manufacture-box">
			<div class="garage-car-showroom-element-manufacture-logo-box normal" style="background-image:url(images/manufacturers/[:manufacturer_name]_logo.png);"></div>
			<div class="garage-car-showroom-element-manufacture-name-box">
				<div class="garage-car-showroom-element-manufacture-name">[:manufacturer_name]</div>
				<div class="garage-car-showroom-element-model-name">[:name]</div>
			</div>
		</div>
		<div class="garage-car-showroom-element-data-info-box">
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Top speed <span>[:eval floor(top_speed/10000)]</span> <b>km/h</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style="width:[:eval ((top_speed/100)*100)]%"></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Acceleration <span>[:eval floor(acceleration/1000)/10]</span> <b>s</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style="width:[:eval ((acceleration/100)*100)]%"></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Braking <span>[:braking]</span></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style="width:[:eval ((braking/100)*100)]%"></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Handling <span>[:handling]</span></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style="width:[:eval ((handling/100)*100)]%"></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Weight <span>[:weight]</span> <b>kg</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style="width:[:eval ((weight/100)*100)]%"></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Improve <span>[:improvement]</span> <b>%</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar ui-corner-all-1px" style="width:[:eval floor(improvement/1000)]%"></div>
				</div>
			</div>
			<div class="garage-car-showroom-element-info-data-box">
				<div class="garage-car-showroom-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> <b>%</b></div>
				<div class="garage-car-showroom-element-progress-bar-box ui-corner-all-1px">
					<div class="garage-car-showroom-element-progress-bar garage-car-showroom-element-progress-bar-used ui-corner-all-1px" style="width:[:eval floor(wear/1000)]%"></div>
				</div>
			</div>
		</div>
		<div class="garage-car-showroom-element-buttons-box">
			<div class="garage-car-showroom-element-active-button-container">
				[:when (active == false)]{
					[:when (ready == true)]{<a href="#Car/activate?id=[:id]" class="button width-100p" module="GARAGE_CAR_SET_ACTIVE">set active</a>}
					[:when (ready == false)]{<a href="#Garage/carReady?id=[:id]" class="button width-100p" module="GARAGE_CAR_SET_ACTIVE_FAIL">set active</a>}
				}
			</div>
			<div class="garage-car-showroom-element-action-button-container garage-part-element-buttons-container button-box-wider">
				[:when ((wear > 0 ) & (active == false))]{
					[:when (wear > 0 )]{<a href="#Garage/car?car_instance_id=[:id]" class="button float-left cmd-repair width-47p" module="GARAGE_TASK">repair<div>&nbsp;</div></a>}
					[:when (active == false)]{<a href="#Garage/car?car_instance_id=[:id]" class="button float-right width-47p" module="GARAGE_CAR_SELL">sell<div>&nbsp;</div></a>}
				}
				[:when ((wear > 0 ) & (active == true))]{
					<a href="#Garage/car?car_instance_id=[:id]" class="button cmd-repair width-100p no-icon" module="GARAGE_TASK">repair<div>&nbsp;</div></a>
				}
				[:when ((wear < 1 ) & (active == false))]{
					<a href="#Garage/car?car_instance_id=[:id]" class="button width-100p" module="GARAGE_CAR_SELL">sell<div>&nbsp;</div></a>
				}
			</div>
			<div class="garage-car-showroom-element-info-button-container">
				<a href="#Garage/car?car_instance_id=[:id]&car_id=[:car_id]" class="button width-47p" module="GARAGE_CAR_SETUP">set up</a>
				<a href="#Garage/car?car_instance_id=[:id]" class="button float-right width-47p" module="GARAGE_CAR_INFO">info</a>
			</div>
		</div>
		<div class="dialog-corner dialog-corner-tl dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-tl dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-tr dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-tr dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-bl dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-bl dialog-corner-v"></div>
		<div class="dialog-corner dialog-corner-br dialog-corner-h"></div>
		<div class="dialog-corner dialog-corner-br dialog-corner-v"></div>
	</div>
</li>