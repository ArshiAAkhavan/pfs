import re
import os
import functools
import matplotlib.pyplot as plt


def plot_chart(experiment_type, metric_name, experiment_results):
    """
    Plots a chart comparing the results of the experiments for the given experiment type and metric name.

    Args:
        experiment_type: The type of experiment, e.g., "random-read" or "sequential-write".
        metric_name: The name of the metric, e.g., "IOPS" or "total runtime".
        experiment_results: A dictionary of experiment results, where the keys are the experiment names and the values are tuples of (IOPS, total runtime).
    """

    # Get the experiment names and metric values.
    experiment_names = list(experiment_results.keys())
    metric_values = [
        experiment_results[experiment_name][experiment_type][metric_name]
        for experiment_name in experiment_names
    ]

    # Create a bar chart.
    plt.bar(experiment_names, metric_values)

    # Set the chart title and labels.
    plt.title(f"{experiment_type} - {metric_name}")
    plt.xlabel("Experiment Name")
    plt.ylabel(metric_name)

    # Show the chart.
    plt.show()


def parse_fio_output(filename: str):
    with open(filename, "r") as f:
        fio_output = f.read()

    # Extract IOPS
    iops_match = re.search(r"IOPS=((\d+)(\.\d+)?)(k?)", fio_output)
    if iops_match is None:
        raise ValueError("Could not find IOPS in FIO output.")
    base = float(iops_match.group(1))
    unit = 1000 if iops_match.group(4) else 1
    iops = int(base * unit)

    # Extract bandwith
    bandwith_match = re.search(r"bw=((\d+)(\.\d+)?)(MiB/s?)", fio_output)
    if bandwith_match is None:
        raise ValueError("Could not find BW in FIO output.")
    base = float(bandwith_match.group(1))
    unit = 1000*1000 if bandwith_match.group(4) else 1
    bandwith = int(base * unit)

    # Extract total runtime
    runtime_match = re.search(r"run=\S*-(\d+)msec", fio_output)
    if runtime_match is None:
        raise ValueError("Could not find total runtime in FIO output.")
    runtime = int(runtime_match.group(1)) / 1000

    return iops, bandwith, runtime


if __name__ == "__main__":
    bench_types = ["random-read", "random-write", "sequential-read", "sequential-write"]
    benches = {"ceph-sdb": {}, "ceph-ssd": {}, "beegfs-ssd": {}, "beegfs-sdb": {}}
    for bench in benches:
        for bench_type in bench_types:
            benches[bench][bench_type] = []

    for bench_name, bench_res in benches.items():
        i = 1
        filename_prefix = f"{bench_name}-{i}"
        while os.system(f"ls out/{filename_prefix}-*") == 0:
            for bench_type in bench_types:
                iops, bw, runtime = parse_fio_output(
                    f"out/{filename_prefix}-{bench_type}.txt"
                )
                bench_res[bench_type].append((iops, bw,runtime))
            i += 1
            filename_prefix = f"{bench_name}-{i}"

    benches_avg = {}
    for key, res in benches.items():
        benches_avg[key] = {}
        for bench_type, metrics in res.items():
            avg_metric = functools.reduce(
                lambda x, y: (x[0] + y[0], x[1] + y[1], x[2] + y[2]), metrics
            )
            benches_avg[key][bench_type] = {
                "iops": avg_metric[0] / len(metrics),
                "bw": avg_metric[1] / len(metrics),
                "runtime": avg_metric[2] / len(metrics),
            }
    print(benches_avg)

    # Plot the charts.
    for experiment_type in bench_types:
        for metric_name in ["iops", "bw", "runtime"]:
            plot_chart(experiment_type, metric_name, benches_avg)
