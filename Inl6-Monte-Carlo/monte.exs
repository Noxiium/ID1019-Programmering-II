defmodule Monte do



  def do_estimate_pi(iterations, radius) do
    a = round(1000, radius, 0)
    rounds(iterations, 1000, radius, a)
  end

  def rounds(0, number_of_points, _, points_inside) do
    estimate_pi(points_inside, number_of_points)
  end
  def rounds(iteration, number_of_points, radius, points_inside) do
    points_inside = round(number_of_points, radius, points_inside)
    number_of_points = number_of_points*2
    pi = estimate_pi(points_inside, number_of_points)
    :io.format(" rounds = ~12w, pi = ~14.10f\n", [number_of_points, pi])
    rounds(iteration-1, number_of_points, radius, points_inside)
  end


  def round(0, _, points_inside), do: points_inside
  def round(i, radius, points_inside) do
    if random_point(radius) do
      round(i-1, radius, points_inside+1)
    else
      round(i-1, radius, points_inside)
    end
  end

  def random_point(radius) do
    x = Enum.random(0..radius)
    y = Enum.random(0..radius)
    :math.pow(radius,2) > (:math.pow(x,2) + :math.pow(y,2))
  end

  def estimate_pi(points_inside, total_points_done) do
    4 * (points_inside / total_points_done)
  end
end
