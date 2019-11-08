class Textamp < Ovto::App
  class Body < Ovto::Component
    def render
      o "div" do
        o "h1", "Textamp"

        o "p" do
          o "span", "volume"
          o "select", {
            name: "volume",
            onchange: ->(e){ actions.set_volume(value: e.target.value) },
          } do
            0.step(10 ** state.increment_digit) do |i|
              hash = {value: i}
              hash[:selected] = "selected" if i == state.volume
              o "option", hash, i
            end
          end
          o "span", "　"
          hash = {
            type: "checkbox",
            name: "linefeed",
            onchange: ->(e){ actions.set_linefeed(value: e.target.checked) },
          }
          hash[:checked] = "checked" if state.linefeed
          o "input", hash
          o "span", "line feed"
        end

        o "p" do
          # NOTE: OFFにする場面がなさそう
          #hash = {
          #  type: "checkbox",
          #  name: "increment",
          #  onchange: ->(e){ actions.set_increment(value: e.target.checked) },
          #}
          #hash[:checked] = "checked" if state.increment
          #o "input", hash
          #o "span", "increment"
          #o "span", "　"
          o "span", "sign"
          o "select", {
            name: "increment_sign",
            onchange: ->(e){ actions.set_increment_sign(value: e.target.value) },
          } do
            %w(# $ o " & @ + * ? _ -).each do |sign|
              hash = {value: sign}
              hash[:selected] = "selected" if sign == state.increment_sign
              o "option", hash, sign
            end
          end
          o "span", "　"
          o "span", "start"
          o "select", {
            name: "increment_start",
            onchange: ->(e){ actions.set_increment_start(value: e.target.value) },
          } do
            [0, 1].each do |i|
              hash = {value: i}
              hash[:selected] = "selected" if i == state.increment_start.to_i
              o "option", hash, i
            end
          end
          o "span", "　"
          o "span", "digit"
          o "select", {
            name: "increment_digit",
            onchange: ->(e){ actions.set_increment_digit(value: e.target.value) },
          } do
            1.upto(4).each do |i|
              hash = {value: i}
              hash[:selected] = "selected" if i == state.increment_digit.to_i
              o "option", hash, i
            end
          end
        end

        # NOTE: template機能はUIが改善するまで非表示
        #o "p" do
        #  hash = {
        #    type: "checkbox",
        #    name: "template",
        #    onchange: ->(e){ actions.set_template(value: e.target.checked) },
        #  }
        #  hash[:checked] = "checked" if state.template
        #  o "input", hash
        #  o "span", "template (experimental)"
        #  o "span", "　"
        #  o "span", "sign"
        #  o "input", {
        #    type: "text",
        #    name: "template_sign",
        #    size: 5,
        #    value: state.template_sign,
        #    oninput: ->(e){ actions.set_template_sign(value: e.target.value) },
        #  }
        #  o "span", "　"
        #  o "span", "parts"
        #  o "textarea", {
        #    name: "template_text",
        #    cols: 20,
        #    rows: 1,
        #    oninput: ->(e){ actions.set_template_text(value: e.target.value) },
        #  }, state.template_text
        #end

        o "p" do
          o "textarea", {
            name: "text",
            cols: 40,
            rows: 5,
            oninput: ->(e){ actions.set_text(value: e.target.value) },
          }, state.text
        end

        o "p" do
          o "textarea", {cols: 40, rows: 20}, state.result
        end
      end
    end
  end
end
