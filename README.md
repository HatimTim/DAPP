# DAPP Test Plan

1. Create Persona Contract  => Test OK
2. Send Ether from Persona Owner account to Persona Account => Test OK
3. Verifiy Default Minion Creation => Test OK.
4. Create Mionon Contract from Minion Account: construnctor("name, "PersonaAddress") => Test OK
5. Minion Can receiveEther from anyone => Test OK
6. Add Minion contract to Controlled List (funtion controlMinion) => Test OK
7. Verify that Persona Address in permission List => Test OK.
8. request Ether from Minion Contract to Persona Contract => Test OK
9. Verify Ether request in Persona Contract => Test OK
10. Send requested Ether from Persona Contract to Minion Contract => Test OK
11. Destroy Minion contract by a call from Persona Contract => Test OK
12. Only Authorized address can call Minion Contract => Test OK
13. Minion cntract cen send ether to specified Address. => Test OK
14. Add More address in permission List by Persona => Test OK.
15. Send Ether to defaultMinion Contract. => Test OK.
16. Destroy DefaultMinion by Persona Power => Test OK. 
