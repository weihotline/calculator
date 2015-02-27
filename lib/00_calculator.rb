class Calculator

  def initialize
    @cal_stack = []
    @exp = []
  end

  def enter(op)
    if op == "="
      result = evaluate(read)
      clear
      return result
    else
      @exp << op.to_s
    end

    nil
  end

  def read
    @exp.join(" ")
  end

  def backspace
    @exp.pop; read
  end

  def clear
    @exp = []; ""
  end

  def evaluate(exp)
    rpn = self.class.convertToPostfix(exp)
    rpn = tokenize(rpn)

    until rpn.count == 0
      ea = rpn.shift

      if ea.is_a?(Numeric)
        @cal_stack << ea
      else
        calculate(ea)
      end
    end

    format(@cal_stack.pop || 0)
  end

  def self.convertToPostfix(infix)
    infix = infix.scan(/\d+\.\d+|\d+|[\+\-\*\/\^\(\)]/)
    postfix = []
    opt_stack = []
    top_opt = ""

    infix.each do |next_char|
      done = false

      if isNumeric?(next_char)
        postfix << next_char
      else
        case next_char
        when "^"
          opt_stack << next_char
        when "+", "-", "*", "/"
          while !done && !opt_stack.empty?
            top_opt = opt_stack.last

            if getPrecedence(next_char) <= getPrecedence(top_opt)
              postfix << top_opt
              opt_stack.pop
            else
              done = true
            end
          end # end until

          opt_stack << next_char
        when "("
          opt_stack << next_char
        when ")"
          top_opt = opt_stack.pop

          until top_opt == "("
            postfix << top_opt
            top_opt = opt_stack.pop
          end
        end # end case
      end # end if
    end # end each-loop

    until opt_stack.empty?
      postfix << opt_stack.pop
    end

    postfix
  end

  private
    def tokenize(rpn)
      rpn.map do |ea|
        %w[+ - * / ^].include?(ea) ? ea.to_sym : ea.to_f
      end
    end

    def format(ans)
      ans % 1 == 0 ? ans.to_i : ans
    end

    def calculate(sign)
      right_num, left_num = @cal_stack.pop, @cal_stack.pop
      raise "Invalid Expression!" if right_num.nil? || left_num.nil?

      value = case sign
        when :+
          left_num + right_num
        when :-
          left_num - right_num
        when :*
          left_num * right_num
        when :/
          left_num / right_num
        when :^
          left_num ** right_num
      end

      @cal_stack << value
    end

    def self.isNumeric?(char)
      !!(char =~ /^\d+/)
    end

    def self.getPrecedence(opt)
      case opt
        when "(", ")" then 0
        when "+", "-" then 1
        when "*", "/" then 2
        when "^" then 3
      end
    end
end
