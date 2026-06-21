# `tools/bayesian/` — deterministic Bayesian math engines

**Reason in bands (Very Low … Very High); call these tools when you need an exact, defensible number.** This is
the neuro-symbolic / deterministic-harness pattern: the agent does qualitative reasoning, these scripts do the
arithmetic. Full doctrine: [`docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md`](../../docs/BAYESIAN_REASONING_UNDER_UNCERTAINTY.md).

| Script | Purpose |
|---|---|
| `bands.py` | The five-band scale + `prob_to_band(p)` (every tool reports a number **and** its band). |
| `vulnerability_calculator.py` | Posterior P(vuln \| alert) from prior + TPR + FPR, with a per-10k-host population projection (makes the base-rate trap concrete). |
| `exploit_chain_simulator.py` | Conditional multi-stage path probability; shows how one mitigation collapses the downstream chain. |

Pure standard-library Python 3 (no dependencies). Run any script directly to see a worked example:

```bash
python3 tools/bayesian/vulnerability_calculator.py
python3 tools/bayesian/exploit_chain_simulator.py
```

Import them in your own orchestration:

```python
from vulnerability_calculator import BayesianVulnerabilityCalculator
r = BayesianVulnerabilityCalculator().calculate_posterior(prior_prob=0.05, true_positive_rate=0.95, false_positive_rate=0.10)
# r["posterior_probability"], r["posterior_band"]
```

A telemetry broker can feed real events (Kali/Metasploit + AWS GuardDuty/Security Hub/Inspector ASFF) into these
engines to compute **empirical** P(detection | attack) for the purple-team loop — see the doctrine §9.
