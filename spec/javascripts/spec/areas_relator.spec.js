describe('Areas relator', function() {
  "use strict";

  var $form;

  beforeEach(function() {
    $form = $('<form>\
      <div class="related-areas">\
        <input type="checkbox" id="all_regions" class="areas-chkbx"/>\
        <input type="checkbox" id="english_regions" class="areas-chkbx"/>\
        <select id="edition_area_gss_codes" multiple="multiple">\
          <option value="E15000007" data-type="EUR" data-country="England">London</option>\
          <option value="E15000008" data-type="EUR" data-country="England">South East</option>\
          <option selected="selected" value="E09000012" data-type="LBO" data-country="England">Hackney Borough Council</option>\
          <option value="S15000001" data-type="EUR" data-country="Scotland">Scotland</option>\
        </select>\
      </div>\
    </form>\
    <script src="/assets/views/business_support/areas_relator.js"></script>');

    $('body').append($form);
  });

  afterEach(function() {
    $form.remove();
  });

  describe('initialising a select2 element', function() {
    it('should add areas data to the select2', function() {
      expect($form.find('.select2-choices li').length).toBe(2);
      expect($form.find('.select2-choices .js-area-name').text()).toEqual("Hackney Borough Council");
    });
  });

  describe('checking the all UK areas checkbox', function() {
    it('should add all areas the target select2 element', function() {
      $form.find('#all_regions').trigger('click');
      expect($form.find('.select2-choices li').length).toBe(4);
      expect($form.find('.select2-choices li:first-child .js-area-name').text()).toEqual("London");
      expect($form.find('.select2-choices li:nth-child(2) .js-area-name').text()).toEqual("South East");
      expect($form.find('.select2-choices li:nth-child(3) .js-area-name').text()).toEqual("Scotland");
    });
  });

  describe('checking the english areas checkbox', function() {
    it('should add english areas to the target select2 element', function() {
      $form.find('#english_regions').trigger('click');
      expect($form.find('.select2-choices li').length).toBe(3);
      expect($form.find('.select2-choices li:first-child .js-area-name').text()).toEqual("London");
      expect($form.find('.select2-choices li:nth-child(2) .js-area-name').text()).toEqual("South East");
    });
  });

  describe('checking english areas when uk areas is checked', function() {
    it('should deselect uk areas', function() {
      $form.find('#all_regions').prop('checked', true);
      $form.find('#english_regions').trigger('click');
      expect($form.find('#all_regions').prop('checked')).toBeFalsy();
    });
  });

  describe('checking uk areas when english areas is checked', function() {
    it('should deselect english areas', function() {
      $form.find('#english_regions').prop('checked', true);
      $form.find('#all_regions').trigger('click');
      expect($form.find('#english_regions').prop('checked')).toBeFalsy();
    });
  });

  describe('removing an area when uk areas is checked', function() {
    it('should deselect uk areas', function() {
      $form.find('#all_regions').trigger('click');
      expect($form.find('#all_regions').prop('checked')).toBeTruthy();
      $form.find('.select2-choices li:first-child .select2-search-choice-close').trigger('click');
      expect($form.find('#all_regions').prop('checked')).toBeFalsy();
    });
  });

  describe('removing an area when english areas is checked', function() {
    it('should deselect english areas', function() {
      $form.find('#english_regions').trigger('click');
      expect($form.find('#english_regions').prop('checked')).toBeTruthy();
      $form.find('.select2-choices li:first-child .select2-search-choice-close').trigger('click');
      expect($form.find('#english_regions').prop('checked')).toBeFalsy();
    });
  });
});
