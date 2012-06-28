<div class="big-element-container big-element-containerw100p big-element-containernm ui-corner-all">
	<div class="big-element-image-container big-element-image-container155 ui-corner-left">
		<img src="test_store/car_[:0.id].jpg?t=[:eval TIMESTAMP(0.id)]" alt="" border="0" width="360" height="195" class="big-element-car-image ui-corner-left" />
		<div class="big-element-image-overlay ui-corner-all">&nbsp;</div>
	</div>
	<div class="big-element-info-container big-element-info-containerw360 big-element-info-container155">
		<div class="big-element-info-box big-element-info-box100p">
			<div class="big-element-info-about">
				<div>Manufacturer:&nbsp;<b>[:0.manufacturer_name]</b></div>
				<div>Model:&nbsp;<b>[:0.name]</b></div>
				<div>Year:&nbsp;<b>[:0.year]</b></div>
				<div>Level:&nbsp;<b>[:0.level]</b></div>
			</div>
			<div class="big-element-info-data">
				<div class="big-element-info-data-box-container">
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Top speed <span>[:0.top_speed]</span> km/h</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.top_speed/100)*100)]%"></div>
						</div>
					</div>
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Acceleration <span>[:0.acceleration]</span> s</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.acceleration/100)*100)]%"></div>
						</div>
					</div>
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Braking <span>[:0.braking]</span></div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.braking/100)*100)]%"></div>
						</div>
					</div>
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Handling <span>[:0.handling]</span></div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.handling/100)*100)]%"></div>
						</div>
					</div>
					<div class="big-element-info-data-box">
						<div class="big-element-info-data-name">Weight <span>[:0.weight]</span> kg</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small ui-corner-all-2px" style="width:[:eval ((0.weight/100)*100)]%"></div>
						</div>
					</div>
					<div class="small-element-info-data-box">
						<div class="small-element-info-data-name">Used <span>[:eval floor(0.wear/1000)]</span> %</div>
						<div class="progress-bar-box-small ui-corner-all-2px">
							<div class="progress-bar-small progress-bar-info-used185 ui-corner-all-2px" style="width:[:eval floor(0.wear/1000)]%"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="crearfix"></div>
</div>