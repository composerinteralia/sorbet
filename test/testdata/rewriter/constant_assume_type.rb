# typed: true

class NormalClass
end

class NewIsNilable
  extend T::Sig

  sig {returns(T.nilable(T.attached_class))}
  def self.new
    return if [true, false].sample
    super
  end
end

class NewIsSpecific
  extend T::Sig

  sig {returns(NewIsSpecificChild)}
  def self.new
    NewIsSpecificChild.new
  end
end
class NewIsSpecificChild < NewIsSpecific
end

A = NormalClass.new
T.reveal_type(A) # error: `NormalClass`

B = NewIsNilable.new # error: Assumed expression had type `NewIsNilable` but found `T.nilable(NewIsNilable)`
T.reveal_type(B) # error: `NewIsNilable`

C1 = NewIsSpecific.new
T.reveal_type(C1) # error: `NewIsSpecific`
C2 = T.let(NewIsSpecific.new, NewIsSpecific)
T.reveal_type(C2) # error: `NewIsSpecific`
C3 = NewIsSpecificChild.new
T.reveal_type(C3) # error: `NewIsSpecificChild`

D1 = Integer.new # error: Expected `String` but found `Integer` for field
D1 = String.new

D2 = T.let(0, Integer)
D2 = T.let('', String)

E1 = Integer.new
E2 = '' + ''

F1 = 0 + 0
F2 = String.new

G1 = T.let(0, Integer)
G2 = String.new

H1 = 0 + 0
H2 = T.let('', String)

class SomethingThatHasNew
  def new; end
end
NotAClass = SomethingThatHasNew.new

I = NotAClass.new
T.reveal_type(I) # error: `T.untyped`
