
/*!
 * JSizes - JQuery plugin v0.32
 *
 * Licensed under the revised BSD License.
 * Copyright 2008-2009 Bram Stein
 * All rights reserved.
 */
/*global jQuery*/
(function ($) {
	var num = function (value) {
		return parseInt(value, 10) || 0;
	};

	/**
	 * Sets or gets the values for min-width, min-height, max-width
	 * and max-height.
	 */
	$.each(['min', 'max'], function (i, name) {
		$.fn[name + 'Size'] = function (value) {
			var width, height;
			if (value) {
				if (value.width) {
					this.css(name + '-width', value.width);
				}
				if (value.height) {
					this.css(name + '-height', value.height);
				}
				return this;
			}
			else {
				width = this.css(name + '-width');
				height = this.css(name + '-height');
				// Apparently:
				//  * Opera returns -1px instead of none
				//  * IE6 returns undefined instead of none
				return {'width': (name === 'max' && (width === undefined || width === 'none' || num(width) === -1) && Number.MAX_VALUE) || num(width),
						'height': (name === 'max' && (height === undefined || height === 'none' || num(height) === -1) && Number.MAX_VALUE) || num(height)};
			}
		};
	});

	/**
	 * Returns whether or not an element is visible.
	 */
	$.fn.isVisible = function () {
		return /*this.css('visibility') !== 'hidden' &&*/ this.css('display') !== 'none';
	};

	/**
	 * Sets or gets the values for border, margin and padding.
	 */
	$.each(['border', 'margin', 'padding'], function (i, name) {
		$.fn[name] = function (value) {
			if (value) {
				if (value.top) {
					this.css(name + '-top' + (name === 'border' ? '-width' : ''), value.top);
				}
				if (value.bottom) {
					this.css(name + '-bottom' + (name === 'border' ? '-width' : ''), value.bottom);
				}
				if (value.left) {
					this.css(name + '-left' + (name === 'border' ? '-width' : ''), value.left);
				}
				if (value.right) {
					this.css(name + '-right' + (name === 'border' ? '-width' : ''), value.right);
				}
				return this;
			}
			else {
				return {top: num(this.css(name + '-top' + (name === 'border' ? '-width' : ''))),
						bottom: num(this.css(name + '-bottom' + (name === 'border' ? '-width' : ''))),
						left: num(this.css(name + '-left' + (name === 'border' ? '-width' : ''))),
						right: num(this.css(name + '-right' + (name === 'border' ? '-width' : '')))};
			}
		};
	});
})(jQuery);