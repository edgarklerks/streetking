<ul class="additional-menu additional-menu120 sk-tab-icons">
	[:when (requestParams.list == 0)]{
		<li class="sk-tab-icons-carshowroom ui-state-default ui-state-focus ui-tabs-selected ui-state-active"><a module="GARAGE_CARS" href="#Garage/cars/?list=0" alt="Car showroom" title="Car showroom">&nbsp;</a></li>
<!--		<li class="sk-tab-icons-carshowroom ui-state-default ui-state-focus ui-tabs-selected ui-state-active">&nbsp;</li>-->
		<li class="sk-tab-icons-carslist"><a module="GARAGE_CARS_LIST" href="#Garage/cars/?list=1" alt="Car list" title="Car list">&nbsp;</a></li>
	}
	[:when (requestParams.list == 1)]{
		<li class="sk-tab-icons-carshowroom"><a module="GARAGE_CARS" href="#Garage/cars/?list=0" alt="Car showroom" title="Car showroom">&nbsp;</a></li>
		<li class="sk-tab-icons-carslist ui-state-default ui-state-focus ui-tabs-selected ui-state-active"><a module="GARAGE_CARS_LIST" href="#Garage/cars/?list=1" alt="Car list" title="Car list">&nbsp;</a></li>
<!--		<li class="sk-tab-icons-carslist ui-state-default ui-state-focus ui-tabs-selected ui-state-active">&nbsp;</li>-->
	}
</ul>