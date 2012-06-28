<div class="big-element-container [:when (improvement > 0 & unique == false)]{big-element-container-improved}[:when (unique)]{big-element-container-unique} ui-corner-all">
	<div class="big-element-image-container [:when (improvement > 0 & unique == false)]{big-element-image-container-improved}[:when (unique)]{big-element-image-container-unique}">
		<div class="big-element-image-box sk-icon-148x148 sk-icon-148x148-body">&nbsp;</div>
	</div>
	<div class="big-element-info-container">
		<div class="big-element-info-box">
			<div class="big-element-info-about">
				<div>Manufacturer:&nbsp;<b>[:0.manufacturer_name]</b></div>
				<div>Model:&nbsp;<b>[:0.name]</b></div>
				<div>Year:&nbsp;<b>[:0.year]</b></div>
				<div>Level:&nbsp;<b>[:0.level]</b></div>
				<div>Price:&nbsp;<b class="red">SK$ [:0.price]</b></div>
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
				</div>
			</div>
		</div>
		<div class="big-element-button-box">
			[:when (requestParams.action == "Market/model/")]{<a href="#Car/buy?id=[:0.id]" class="button part-button" module="MARKETPLACE_NEWCAR_BUY">buy</a>}
		</div>
	</div>
	<div class="crearfix"></div>
</div>