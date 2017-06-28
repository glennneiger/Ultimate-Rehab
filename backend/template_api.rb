require 'docile'

PRODUCT_TEMPLATES = { }
ROOM_TEMPLATES = { }

LINEAR_FEET_DETAIL = 'Linear Feet'
SQUARE_FEET_DETAIL = 'Square Feet'
SELECTED_DETAIL = 'Selected'
QUANTITY_DETAIL = 'Quantity'
STEPS_DETAIL = 'Steps'

class ProductBuilder
    def template_id(x); @template_id = x; self; end;
    def name(x); @name = x; self; end;
    def shortname(x); @shortname = x; self; end;
    def misc(x); @misc = x; self; end;
    def taxable(x); @taxable = x; self; end;
    def materials_cost(*args)
        if args.size == 0
            return @materials_cost
        else
            @materials_cost = args[0]
            return self
        end
    end
    def labor_cost(*args)
        if args.size == 0
            return @labor_cost
        else
            @labor_cost = args[0]
            return self
        end
    end
    def hd_sku(x); @hd_sku = x; self; end;
    def detail(&block)
        @detail = addDetail2(&block)
        self
    end
    def materials_cost_total_fn(x); @materials_cost_total_fn = x; self; end;
    def labor_cost_total_fn(x); @labor_cost_total_fn = x; self; end;
    def quantity_fn(x); @quantity_fn = x; self; end;

    def build
        if !@template_id.is_a?(Symbol)
            raise "'template_id' must be a Symbol"
        end
        if !@name.is_a?(String)
            raise "'name' must be a String"
        end
        if !(@shortname.is_a?(String) or @shortname.nil?)
            raise "'shortname' must be a String"
        end
        if !(@misc.is_a?(String) or @misc.nil?)
            raise "'misc' must be a String"
        end
        if !(@taxable == true or @taxable == false or @taxable.nil?)
            raise "'taxable' must be Boolean or nil"
        end
        if !@materials_cost.is_a?(Float)
            raise "'materials_cost' must be a Float"
        end
        if !@labor_cost.is_a?(Float)
            raise "'labor_cost' must be a Float"
        end
        if !(@hd_sku.is_a?(Fixnum) or @hd_sku.nil?)
            raise "'hd_sku' must be a Fixnum or nil"
        end
        if !(@detail.is_a?(Hash) and @detail['name'].is_a?(String))
            raise "'detail' must be a String"
        end
        if !@materials_cost_total_fn.is_a?(String)
            raise "'materials_cost_total_fn' must be a String"
        end
        if !@labor_cost_total_fn.is_a?(String)
            raise "'labor_cost_total_fn' must be a String"
        end
        if !@quantity_fn.is_a?(String)
            raise "'quantity_fn' must be a String"
        end

        {
            'template_id' => @template_id,
            'name' => @name,
            'shortname' => @shortname || @name,
            'misc' => @misc || '',
            'taxable' => @taxable.nil? ? true : @taxable,
            'materials_cost' => @materials_cost,
            'labor_cost' => @labor_cost,
            'hd_sku' => @hd_sku,
            'detail' => @detail,
            'materials_cost_total_fn' => @materials_cost_total_fn,
            'labor_cost_total_fn' => @labor_cost_total_fn,
            'quantity_fn' => @quantity_fn
        }
    end
end

def addProduct2(&block)
    x = Docile.dsl_eval(ProductBuilder.new, &block).build
    if PRODUCT_TEMPLATES.key?(x['template_id'])
        puts x
        raise "duplicate product template_id"
    end
    PRODUCT_TEMPLATES[x['template_id']] = x
end

class DetailBuilder
    def name(x); @name = x; self; end
    def units(x); @units = x; self; end

    def build
        if !@name.is_a?(String)
            raise "detail 'name' must be a String"
        end
        if !(@units.is_a?(String) or @units.nil?)
            raise "detail 'units' must be a String"
        end

        {
            'name' => @name,
            'units' => @units,
        }
    end
end

def addDetail2(&block)
    Docile.dsl_eval(DetailBuilder.new, &block).build
end

class RoomBuilder
    def initialize
        @sections = {}
        @measurements = []
        @calculated_measurements = {}
    end

    def template_id(x); @template_id = x; self; end;
    def name(x); @name = x; self; end;
    def section(&block)
        x = addSection2(&block)
        if @sections.key?(x['name'])
            raise "duplicate section name"
        end
        @sections[x['name']] = x
        self
    end
    def measurement(x)
        if @measurements.index(x) or @calculated_measurements.key?(x)
            raise 'duplicate measurement name'
        end
        @measurements.push(x)
        self
    end
    def calculated_measurement(&block)
        x = addCalculatedMeasurement2(&block)
        if @measurements.index(x['name']) or @calculated_measurements.key?(x['name'])
            raise 'duplicate measurement name'
        end
        @calculated_measurements[x['name']] = x
        self
    end

    def build
        if !@template_id.is_a?(Symbol)
            raise "'template_id' must be a Symbol"
        end
        if !@name.is_a?(String)
            raise "'name' must be a String"
        end
        if !@sections.is_a?(Hash)
            raise "'sections' must be a Hash"
        end
        if !@measurements.is_a?(Array)
            raise "'measurements' must be a Array"
        end

        {
            'template_id' => @template_id,
            'name' => @name,
            'sections' => @sections,
            'measurements' => @measurements,
            'calculated_measurements' => @calculated_measurements,
        }
    end
end

def addRoom2(&block)
    x = Docile.dsl_eval(RoomBuilder.new, &block).build
    if ROOM_TEMPLATES.key?(x['template_id'])
        raise "duplicate room template_id"
    end
    ROOM_TEMPLATES[x['template_id']] = x
end

class SectionBuilder
    def initialize
        @products = []
    end

    def name(x); @name = x; self; end;
    def product(x)
        @products.push(x)
        self
    end

    def build
        if !@name.is_a?(String)
            raise "section 'name' must be String"
        end
        if !@products.all? {|template_id| template_id.is_a?(Symbol) and PRODUCT_TEMPLATES.key?(template_id)}
            raise "section 'products' must be Array of template_id"
        end

        {
            'name' => @name,
            'products' => @products,
        }
    end
end

def addSection2(&block)
    Docile.dsl_eval(SectionBuilder.new, &block).build
end

class CalculatedMeasurementBuilder
    def name(x); @name = x; self; end;
    def show_user(x); @show_user = x; self; end;
    def value_fn(x); @value_fn = x; self; end;

    def build
        if !@name.is_a?(String)
            raise "calculated measurement 'name' must be String"
        end
        if !(@show_user == true or @show_user == false)
            raise "calculated measurement 'show_user' must be Boolean"
        end
        if !@value_fn.is_a?(String)
            raise "calculated measurement 'value_fn' must be String"
        end

        {
            'name' => @name,
            'show_user' => @show_user,
            'value_fn' => @value_fn
        }
    end
end

def addCalculatedMeasurement2(&block)
    Docile.dsl_eval(CalculatedMeasurementBuilder.new, &block).build
end

#############################
#      Javascript API       #
#############################
def detail_times(x)
    "function(d, ms) {return d*#{x}}"
end

def detail_identity
    detail_times(1)
end

def quantity_times(x)
    "function(d, ms, q) {return q*#{x}}"
end

def perimeter_times(x)
    "function(d, ms) {return ms.perimeter*#{x}}"
end

def perimeter_identity
    perimeter_times(1)
end

def floor_area_times(x)
    "function(d, ms) {return ms.floor_area*#{x}}"
end

def floor_area_identity
    floor_area_times(1)
end

def wall_area_times(x)
    "function(d, ms) {return ms.wall_area*#{x}}"
end

def wall_area_identity
    wall_area_times(1)
end

def wall_area_and_floor_area_times(x)
    "function(d, ms) {return (ms.wall_area + ms.floor_area)*#{x}}"
end

def zero
    "function(d, ms) {return 0}"
end
