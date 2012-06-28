<li>
	<div class="setup-tab-slider-element-container [:when (improvement > 0 & unique == false)]{setup-tab-slider-element-container-improved}[:when (unique)]{setup-tab-slider-element-container-unique} ui-corner-all">
		<div class="setup-tab-slider-element-data">
			<div class="setup-tab-slider-element-image-container ui-corner-tl [:when (improvement > 0 & unique == false)]{setup-tab-slider-element-image-container-improved}[:when (unique)]{setup-tab-slider-element-image-container-unique}">
				<div class="setup-tab-slider-element-image-box sk-icons-100x100-white-tr-75 sk-icons-100x100-[:name]">&nbsp;</div>
				<div class="setup-tab-slider-element-level">Level:&nbsp;<b>[:level]</b></div>
			</div>
			<div class="setup-tab-slider-element-info-container">
				<div class="setup-tab-slider-element-info-data-box">
					<div class="setup-tab-slider-element-info-data-name">[:parameter1_name]: <span>+[:parameter1]</span> [:when (parameter1_unit != null)]{[:parameter1_unit]}</div>
					<div class="progress-bar-box-info ui-corner-all-2px">
						<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval (parameter1/100)*100]%"></div>
					</div>
				</div>
				[:when (parameter2_name)]{
					<div class="setup-tab-slider-element-info-data-box">
						<div class="setup-tab-slider-element-info-data-name">[:parameter2_name]: <span>+[:parameter2]</span> [:when (parameter2_unit != null)]{[:parameter2_unit]}</div>
						<div class="progress-bar-box-info ui-corner-all-2px">
							<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval (parameter2/100)*100]%"></div>
						</div>
					</div>
				}
				<div class="setup-tab-slider-element-info-data-box">
					<div class="setup-tab-slider-element-info-data-name">Weight <span>+[:weight]</span> kg</div>
					<div class="progress-bar-box-info ui-corner-all-2px">
						<div class="progress-bar-info ui-corner-all-2px" style="width:[:eval ((weight/100)*100)]%"></div>
					</div>
				</div>
				[:when (unique == false)]{
					<div class="setup-tab-slider-element-info-data-box">
						<div class="setup-tab-slider-element-info-data-name">Improve <span>[:eval floor(improvement/1000)]</span> %</div>
						<div class="progress-bar-box-info ui-corner-all-2px">
							<div class="progress-bar-info progress-bar-info-improve ui-corner-all-2px" style="width:[:eval ((improvement/100000)*100)]%"></div>
						</div>
					</div>
				}
				<div class="setup-tab-slider-element-info-data-box">
					<div class="setup-tab-slider-element-info-data-name">Used <span>[:eval floor(wear/1000)]</span> %</div>
					<div class="progress-bar-box-info ui-corner-all-2px">
						<div class="progress-bar-info progress-bar-info-used136 ui-corner-all-2px" style="width:[:eval floor(wear/1000)]%"></div>
					</div>
				</div>			
			</div>
		</div>
		<div class="setup-tab-slider-element-button-box button-box-wider">
			<a href="#Garage/addPart?part_instance_id=[:part_instance_id]&car_instance_id=[:requestParams.car_instance_id]" changePart="[:part_type_id]" class="button setup-part-button" module="GARAGE_CAR_PART_ADD">add<div>&nbsp;</div></a>
			[:when (unique == false)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=improve_part" class="button setup-part-button cmd-improve" module="GARAGE_TASK">improve<div>&nbsp;</div></a>}
			[:when (wear > 0)]{<a href="#Personnel/task?subject_id=[:part_instance_id]&task=repair_part" class="button setup-part-button cmd-repair" module="GARAGE_TASK">repair<div>&nbsp;</div></a>}
		</div>
		<div class="crearfix"></div>
	</div>
</li>