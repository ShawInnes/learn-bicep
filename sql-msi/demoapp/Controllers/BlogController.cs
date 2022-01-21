using demoapp.Data;
using Microsoft.AspNetCore.Mvc;

namespace demoapp.Controllers;

[ApiController]
[Route("[controller]")]
public class BlogController : ControllerBase
{
    private readonly ILogger<BlogController> _logger;
    private readonly BloggingContext _context;

    public BlogController(ILogger<BlogController> logger, BloggingContext context)
    {
        _logger = logger;
        _context = context;
    }

    [HttpGet(Name = "GetBlog")]
    public IEnumerable<Blog> Get()
    {
        var blogs = _context.Blogs.ToList();

        return blogs;
    }

    [HttpPost(Name = "PostBlog")]
    public Blog Post([FromBody] Blog blog)
    {
        _context.Blogs.Add(blog);
        if (_context.ChangeTracker.HasChanges())
            _context.SaveChanges();

        return blog;
    }
}