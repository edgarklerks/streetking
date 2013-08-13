<div class="award-element-container">
	<div class="award-element-container-inner">
		<div class="award-element-icon-container backgound-blue"><div class="award-element-icon [:when (money)]{award-element-icon-money}[:when (experience)]{award-element-icon-experience}"></div></div>
		<div class="award-element-content-container">
			<div class="award-element-received-text">You received</div>
			<div class="award-element-data-text">
				[:when (money)]{
					<span>[:money]</span> $
				}
				[:when (experience)]{
					<span>[:experience]</span> respect points
				}
			</div>
		</div>
	</div>
</div>