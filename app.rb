require 'ovto'

require "components/body"

class Textamp < Ovto::App
  class State < Ovto::State
    item :text, default: "aaa#"
    item :volume, default: 10
    item :increment, default: true
    item :increment_digit, default: 2
    item :increment_sign, default: "#"
    item :increment_start, default: 0
    item :template, default: false
    item :template_sign, default: ""
    item :template_text, default: ""
    item :linefeed, default: true

    def result
      results = Array.new(volume) { text }

      if increment
        results = do_increment(results)
      end

      if template
        results = do_template(results)
      end

      result = ""
      if linefeed
        result = results.join("\n")
      else
        result = results.join(" ")
      end

      result
    end

    private

    def do_increment(results)
      format = "%0#{increment_digit}d"
      sign = increment_sign
      start = increment_start
      results.map.with_index do |t, i|
        sign_count = t.count(sign)
        part = format % (i + start)
        t.gsub("#{sign}", part)
      end
    end

    def do_template(results)
      sign = template_sign
      results.map.with_index do |t, i|
        template_texts = template_text.split(/\n/)
        part = template_texts[i % template_texts.count].chomp
        t.gsub("#{sign}", part)
      end
    end
  end

  class Actions < Ovto::Actions
    def set_text(value: value)
      return {text: value}
    end

    def set_volume(value: value)
      return {volume: value.to_i}
    end

    def set_increment(value: value)
      return {increment: value}
    end

    def set_increment_digit(value: value)
      return {increment_digit: value.to_i}
    end

    def set_increment_sign(value: value)
      return {increment_sign: value}
    end

    def set_increment_start(value: value)
      return {increment_start: value.to_i}
    end

    def set_template(value: value)
      return {template: value}
    end

    def set_template_sign(value: value)
      return {template_sign: value}
    end

    def set_template_text(value: value)
      return {template_text: value}
    end

    def set_linefeed(value: value)
      return {linefeed: value}
    end
  end

  class MainComponent < Ovto::Component
    def render
      o Body
    end
  end
end

Textamp.run(id: 'ovto')
