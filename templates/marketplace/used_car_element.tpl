<div class="car-element-box ui-corner-all">
	<div class="car-element-image ui-corner-all sk-icon-148x148 sk-icon-148x148-body">&nbsp;</div>
	<div class="car-element-info-box">
		<div class="car-element-info-about">
			<div>Manufacturer:&nbsp;<b>[:manufacturer_name]</b></div>
			<div>Model:&nbsp;<b>[:model]</b></div>
			<div>Year:&nbsp;<b>[:year]</b></div>
			<div>Level:&nbsp;<b>[:level]</b></div>
			<div>Price:&nbsp;<b>SK$ [:price]</b></div>
		</div>
		<div class="car-element-info-data">
			<div class="car-element-info-data-box-container">
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Top speed <span>[:top_speed]</span> (km/h)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((top_speed/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Acceleration <span>[:acceleration]</span> (s)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((acceleration/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Braking <span>[:braking]</span></div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((braking/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Handling <span>[:handling]</span></div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((handling/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Weight <span>[:weight]</span> (kg)</div>
					<div class="progress-bar-box-small">
						<div class="progress-bar-small" style="left:-[:eval 100-((weight/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Improve <span>[:improvement]</span> (%)</div>
					<div class="progress-bar-box-small">
						<div class="progress-improve-bar-small" style="left:-[:eval 100-((improvement/100)*100)]%"></div>
					</div>
				</div>
				<div class="car-element-info-data-box">
					<div class="car-element-info-data-name">Used <span>[:wear]</span> (%)</div>
					<div class="progress-bar-box-small">
						<div class="progress-wear-bar-small" style="width:[:wear]%"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="car-element-button-box">
		<div class="car-element-button-box-container">
			[:when (requestParams.me != 1)]{<a href="#Market/buyCar?car_instance_id=[:car_instance_id]" class="button car-button" module="MARKETPLACE_USEDCAR_BUY">buy</a>}
			[:when (requestParams.me == 1)]{<a href="#Market/returnCar?car_instance_id=[:car_instance_id]" class="button part-button" module="MARKETPLACE_USEDCAR_RETURN">return</a>}
			<a href="#Market/cars/?car_instance_id=[:car_instance_id]" class="button car-button" module="MARKETPLACE_USEDCAR_INFO">info</a>
		</div>
	</div>
	<div class="crearfix"></div>
</div>