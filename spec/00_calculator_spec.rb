require "00_calculator"

RSpec.describe Calculator do
  subject(:calc) { Calculator.new }

  describe "::convertToPostfix" do
    context "when empty string is passed" do
      it "should return empty array" do
        postfix = Calculator.convertToPostfix("")
        expect(postfix.count).to eq 0
      end
    end

    context "when valid infix expression is passed" do
      it "should return an array with postfix notation" do
        postfix = Calculator.convertToPostfix("1+2")
        expect(postfix).to eq ["1", "2", "+"]
      end

      it "should return an array without parenthesis" do
        postfix = Calculator.convertToPostfix("(1+2)*4")
        expect(postfix.include?("(")).to be false
        expect(postfix.include?(")")).to be false
      end

      it "should handle floating number" do
        postfix = Calculator.convertToPostfix("2-1.4*2.5")
        expect(postfix).to eq ["2", "1.4", "2.5", "*", "-"]
      end

      it "should handle whitespaces" do
        postfix = Calculator.convertToPostfix("    1  +   2")
        expect(postfix).to eq ["1", "2", "+"]
      end
    end
  end

  describe "#evaluate" do
    context "when the infix expression is empty" do
      it "should return 0" do
        result = calc.evaluate("")
        expect(result).to eq 0
      end
    end

    context "when valid infix expression is passed" do
      it "should handle simple addition" do
        result = calc.evaluate("1+2")
        expect(result).to eq 3
      end

      it "should handle addition and multiplication" do
        result = calc.evaluate("2+4*5")
        expect(result).to eq 22
      end

      it "should handle exponentiation" do
        result = calc.evaluate("10^2")
        expect(result).to eq 100
      end

      it "should handle parenthesis" do
        result = calc.evaluate("10*2/2+(13-3)")
        expect(result).to eq 20
      end

      it "should handle floating number" do
        result = calc.evaluate("12.1+12.9")
        expect(result.to_s).to eq "25"

        result = calc.evaluate("20/8")
        expect(result).to eq 2.5
      end

      it "everything above" do
        result = calc.evaluate("1 + 2 ^ 3 * (3 + 5 - 4 / 2) - 1.0")
        expect(result).to eq 48
      end
    end
  end

  describe "#enter" do
    context "when it is treated like a calculator" do
      before(:each) do
        calc.enter(10)
        calc.enter("-")
        calc.enter(3)
        calc.enter("*")
        calc.enter("(")
        calc.enter(1)
        calc.enter("+")
        calc.enter(2)
        calc.enter(")")
      end
      it "should keep track of user's entries" do
        expect(calc.read).to eq "10 - 3 * ( 1 + 2 )"
      end

      it "should allow removal of last entry" do
        calc.backspace
        calc.backspace
        expect(calc.read).to eq "10 - 3 * ( 1 +"
      end

      it "should allow expression clearance" do
        calc.clear
        expect(calc.read).to eq ""
      end

      it "should evaluate the stored expression when = is entered" do
        result = calc.enter("=")
        expect(result).to eq 1
      end
    end
  end
end
