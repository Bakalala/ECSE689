from typing import List
from dataclasses import dataclass

class ASTNode:
    pass

class Expr(ASTNode):
    pass

class Stmt(ASTNode):
    pass


@dataclass(frozen=True)
class Mem(ASTNode):
    size: int
    name: str # to track differnet rams

@dataclass(frozen=True)
class Add(Expr):
    left: Expr
    right: Expr

@dataclass(frozen=True)
class Mul(Expr):
    left: Expr
    right: Expr

@dataclass(frozen=True)
class Load(Expr):
    mem: Mem
    addr: Expr

@dataclass(frozen=True)
class Store(Stmt):
    mem: Mem
    addr: Expr
    val: Expr


@dataclass(frozen=True)
class Cst(Expr):
    value: int

@dataclass(frozen=True)
class Block(Stmt):
    stmts: List[Stmt]

@dataclass(frozen=True)
class Var(Expr):
    name: str

@dataclass(frozen=True)
class VarLoad(Expr):
    var: Var

@dataclass(frozen=True)
class VarStore(Stmt):
    var: Var
    val: Expr

@dataclass(frozen=True)
class For(Stmt):
    itVar: Var
    itNum: int
    body: Stmt

