<ul class="sk-tab-icons">
	[:repeat data:tabs.nodes as:currtab] {
		<li class="sk-tab-icons-[:currtab.content.Tab.0]">
			<a href="#Garage/parts/?part_type=[:currtab.content.Tab.0]&car_id=[:car.0.car_id]&car_instance_id=[:car.0.id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="[:currtab.content.Tab.0]" title="[:currtab.content.Tab.0]">&nbsp;</a>
		</li>
	}
	<li class="sk-tab-icons-paint"><a href="#Garage/parts/?part_type=paint&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_PAINT_TAB" alt="paint" title="paint">&nbsp;</a></li>
<!--
	<li class="sk-tab-icons-body_kit"><a href="#Garage/parts/?part_type=body_kit&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="aerodynamic" title="body_kit">&nbsp;</a></li>
	<li class="sk-tab-icons-engine"><a href="#Garage/parts/?part_type=engine&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="engine" title="engine">&nbsp;</a></li>
	<li class="sk-tab-icons-suspension"><a href="#Garage/parts/?part_type=suspension&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="suspension" title="suspension">&nbsp;</a></li>
	<li class="sk-tab-icons-wheel"><a href="#Garage/parts/?part_type=wheel&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="wheel" title="wheel">&nbsp;</a></li>
	<li class="sk-tab-icons-brake"><a href="#Garage/parts/?part_type=brake&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="brake" title="brake">&nbsp;</a></li>
	<li class="sk-tab-icons-turbo"><a href="#Garage/parts/?part_type=turbo&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="turbo" title="turbo">&nbsp;</a></li>
	<li class="sk-tab-icons-spoiler"><a href="#Garage/parts/?part_type=spoiler&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="spoiler" title="spoiler">&nbsp;</a></li>
	<li class="sk-tab-icons-nos"><a href="#Garage/parts/?part_type=nos&car_id=[:0.car_id]&car_instance_id=[:requestParams.car_instance_id]&anycar=1" module="GARAGE_CAR_SETUP_TAB" alt="nos" title="nos">&nbsp;</a></li>
-->
</ul>